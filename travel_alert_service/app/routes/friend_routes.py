from fastapi import APIRouter
from app.services.friend_service import FriendService
from app.models.friend_models import (
    FriendRequest,
    FriendsAvailableCheck,
    FriendsAvailableList,
    SeeAvaialableFriendRequest
)

router = APIRouter(
    tags=['friend routes'],
    prefix='/friends'
)

@router.post('/available', response_model=FriendsAvailableList)
def available_friends(request: FriendsAvailableCheck):
    return FriendService.fetch_available_friends(request.userID)

@router.post('/request')
def request_friends(request: FriendRequest):
    return FriendService.send_friend_requests(request.userID, request.friend_requests)

@router.post('/accept-request')
def accept_friend_request(request: FriendRequest):
    return FriendService.accept_friend_requests(request.userID, request.friend_requests)

@router.post('/pending-requests')
def get_pending_requests_route(request: SeeAvaialableFriendRequest):
    return FriendService.fetch_pending_requests(request.userID)

@router.get('/{userID}')
def get_all_friends(userID: int):
    return FriendService.get_friends_details(userID)