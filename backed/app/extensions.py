from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

# 初始化扩展对象，后续在 app 工厂函数中绑定
db = SQLAlchemy()
cors = CORS()