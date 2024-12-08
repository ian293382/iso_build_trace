from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel
try:
    from typing import Annotated, LI
except ImportError:
    from typing_extensions import Annotated, List
from sqlalchemy.orm import Session
import models
from database import engine, SessionLocal
import uvicorn  # 新增這行以便啟動服務器

# 初始化 FastAPI 應用
app = FastAPI()

# 初始化數據庫
models.Base.metadata.create_all(bind=engine)

# 數據庫連接依賴
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

db_dependency = Annotated[Session, Depends(get_db)]

# Pydantic Schemas
class UserBase(BaseModel):
    username: str

    class Config:
        from_attributes = True

class PostBase(BaseModel):
    title: str
    content: str
    user_id: int

    class Config:
        from_attributes = True

# 路由
@app.post("/users/", status_code=status.HTTP_201_CREATED, response_model=UserBase)
def create_user(user: UserBase, db: db_dependency):
    new_user = models.User(username=user.username)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.get("/users/", response_model=List[UserBase])
def get_users(db: db_dependency):
    users = db.query(models.User).all()
    return users

@app.post("/posts/", status_code=status.HTTP_201_CREATED, response_model=PostBase)
def create_post(post: PostBase, db: db_dependency):
    # 檢查用戶是否存在
    user = db.query(models.User).filter(models.User.id == post.user_id).first()
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    new_post = models.Post(title=post.title, content=post.content, user_id=post.user_id)
    db.add(new_post)
    db.commit()
    db.refresh(new_post)
    return new_post

@app.get("/posts/", response_model=List[PostBase])
def get_posts(db: db_dependency):
    posts = db.query(models.Post).all()
    return posts

@app.get("/posts/{post_id}", response_model=PostBase)
def get_post(post_id: int, db: db_dependency):
    post = db.query(models.Post).filter(models.Post.id == post_id).first()
    if post is None:
        raise HTTPException(status_code=404, detail="Post not found")
    return post

# 新增運行服務器代碼
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=False)
