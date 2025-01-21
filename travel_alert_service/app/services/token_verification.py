from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from grpc import Status

from jose import JWTError, jwt

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
JWT_SECRET = "ktk2_DRrkXXdXTW7swdmwNK6oc7KT2H7d0VgSzsLoas"
JWT_ALGORITHM = "HS256"
VERIFICATION_CODE_EXPIRY_MINUTES = 10

def verify_jwt_token(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise HTTPException(
                status_code=Status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials",
                headers={"WWW-Authenticate": "Bearer"},
            )
        return email  # Return email if valid
    except JWTError:
        raise HTTPException(
            status_code=Status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )