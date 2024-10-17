from fastapi import HTTPException, Header
import jwt 
   
   # get the user token from the headers 
    
def auth_middleware(x_auth_token=Header()):

    try:
        if not x_auth_token:
            raise HTTPException(status_code=401, detail='No auth token, access denied!')
        # decode the token 
        verified_token = jwt.decode(x_auth_token, 'password_key', algorithms=['HS256'])
        if not verified_token:
            raise HTTPException(status_code=401, detail='Token verification failed, authorization denied')
        # get the id from token 
        uid = verified_token.get('id')
        return {'uid':uid, 'token':x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail='Token is not valid, authorization failed')

    # postgres data to get the user info (This part can be implemented if needed)
