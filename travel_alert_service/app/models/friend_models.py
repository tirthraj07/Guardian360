from typing import List
from pydantic import BaseModel, EmailStr

from typing import Optional
from pydantic import BaseModel, EmailStr

class FriendsAvailable(BaseModel):
    userID: int
    email: EmailStr
    first_name: str
    last_name: str
    phone_no: str
    profile_pic_location: Optional[str] = None

class FriendRequest(BaseModel):
    userID: int
    friend_requests: List

class SeeAvaialableFriendRequest(BaseModel):
    userID: int

class FriendsAvailableCheck(BaseModel):
    userID: int

class FriendsAvailableList(BaseModel):
    available_friends: List[FriendsAvailable]  # A list of FriendsAvailable objects
