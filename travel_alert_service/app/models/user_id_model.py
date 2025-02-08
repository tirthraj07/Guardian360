from dataclasses import Field
from datetime import datetime
from typing import Optional
from pydantic import BaseModel

class UserIDModel(BaseModel):
    userID: int
