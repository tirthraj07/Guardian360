from fastapi import APIRouter

router = APIRouter(
    tags=['friend routes'],
    prefix='/friends'
)

@router.post('/request')
def add_friend():
    return {"message" : "He has added You back"}