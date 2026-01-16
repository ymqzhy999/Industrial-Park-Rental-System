from flask import Flask
from .config import Config
from .extensions import db, cors


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # 初始化插件
    db.init_app(app)
    # 允许所有跨域
    cors.init_app(app, resources={
        r"/*": {
            "origins": "*",
            "expose_headers": ["Captcha-ID"]
        }
    })


    # 注册蓝图
    from .api.auth import auth_bp
    app.register_blueprint(auth_bp)
    from app.api.comment import comment_bp
    app.register_blueprint(comment_bp)
    from app.api.admin import admin_bp
    app.register_blueprint(admin_bp)
    from .api.user import user_bp
    app.register_blueprint(user_bp)
    from app.api.notice import notice_bp
    app.register_blueprint(notice_bp)
    from app.api.common import common_bp
    app.register_blueprint(common_bp)
    from .api.factory import factory_bp
    app.register_blueprint(factory_bp)
    from .api.contract import contract_bp
    app.register_blueprint(contract_bp)
    from app.api.payment import payment_bp
    app.register_blueprint(payment_bp)
    from app.api.dashboard import dashboard_bp
    app.register_blueprint(dashboard_bp)
    from app.api.recommend import recommend_bp
    app.register_blueprint(recommend_bp)
    # 简单的初始化数据库路由
    @app.route('/api/init_db')
    def init_db():
        with app.app_context():
            db.create_all()
        return "DB Init Success"

    return app