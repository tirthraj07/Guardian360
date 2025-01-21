from fastapi import APIRouter, HTTPException, status
from grpc import Status
from app.database.crud import add_friend, add_friend_request, get_all_users, get_available_friends
from app.schemas.friend_schema import FriendRequest, FriendsAvailable, FriendsAvailableCheck, FriendsAvailableList

router = APIRouter(
    tags=['friend routes'],
    prefix='/friends'
)

@router.post('/available', response_model=FriendsAvailableList)
def available_friends(request: FriendsAvailableCheck):
    users = get_available_friends(request.userID)
    
    friends = [FriendsAvailable(
        userID=user['userID'],
        email=user['email'],
        first_name=user['first_name'],
        last_name=user['last_name'],
        phone_no=user['phone_no'],
        profile_pic_location=user['profile_pic_location']
    ) for user in users]
    
    return {"available_friends": friends}


@router.post('/request')
def request_friends(request: FriendRequest):
    try:
        userID = request.userID
        requested_user_ids = request.friend_requests


        for receiverID in requested_user_ids:
            try:
                add_friend_request(userID, receiverID)
            except Exception as e:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Error adding friend request for user {receiverID}: {str(e)}"
                )

        return {"message": "Friend request sent successfully"}

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {str(e)}"
        )
    

@router.post('/accept-request')
def accept_friend_request(request: FriendRequest):
    try:
        userID = request.userID
        accepted_user_ids = request.friend_requests


        for receiverID in accepted_user_ids:
            try:
                add_friend(userID, receiverID)
            except Exception as e:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Error adding friend request for user {receiverID}: {str(e)}"
                )

        return {"message": "Friend Added successfully"}

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"An unexpected error occurred: {str(e)}"
        )