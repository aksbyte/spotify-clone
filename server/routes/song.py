import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, UploadFile
from middleware.auth_middleware import auth_middleware
from database import get_db
from sqlalchemy.orm import Session
from models.favorite import Favorite
from models.song import Song
from pydantic_schemas.favorite_song import FavoriteSong
from sqlalchemy.orm import joinedload
from dotenv import load_dotenv
import os

# Load environment variables from the .env file
load_dotenv()

router = APIRouter()

# Configuration using environment variables
cloudinary.config( 
    cloud_name = os.getenv("CLOUDINARY_CLOUD_NAME"), 
    api_key = os.getenv("CLOUDINARY_API_KEY"), 
    api_secret = os.getenv("CLOUDINARY_API_SECRET"), 
    secure=True
)

# (Your remaining code remains unchanged)



@router.post('/upload', status_code=201)
def upload_song(song: UploadFile = File(...), 
                thumbnail: UploadFile = File(...),
                artist:str=Form(...),
                song_name:str=Form(...),
                hex_code:str=Form(...),
                db: Session = Depends(get_db),
                auth_dict = Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}')                
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')                
    # logger(song_res['url'])
    # logger(thumbnail_res['url'])

    new_song = Song(
        id=song_id,
        song_name=song_name,
        artist=artist,
        hex_code=hex_code,
        song_url=song_res['url'],
        thumbnail_url=thumbnail_res['url']
    )

    db.add(new_song)    
    db.commit()
    db.refresh(new_song)    
    return new_song

@router.get('/list')
def list_songs(db: Session = Depends(get_db), auth_details= Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs


@router.post('/favorite')
def favorite_song(song:FavoriteSong, db: Session = Depends(get_db), auth_details= Depends(auth_middleware)):
    # song is already fevorited by the user 
    user_id = auth_details['uid']
    fev_song = db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id == user_id).first()
    if fev_song:
        db.delete(fev_song)
        db.commit()
        return {'message': False}
    else:
        new_fav= Favorite(id=str(uuid.uuid4()), song_id=song.song_id, user_id=user_id )    
        db.add(new_fav)
        db.commit()
        return {'message': True}
    # if the song is already fevorited, unfavorited songs
    # if the song is not favorited, fevorite the song

@router.get('/list/favorites')
def list_fev_songs(db: Session = Depends(get_db), auth_details= Depends(auth_middleware)):
    user_id = auth_details['uid']
    fev_songs = db.query(Favorite).filter(Favorite.user_id == user_id).options(joinedload(Favorite.song)).all()
    
    return fev_songs
