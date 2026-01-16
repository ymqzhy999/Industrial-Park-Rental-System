import datetime
from .extensions import db


class User(db.Model):
    """系统用户表"""
    __tablename__ = 'sys_user'

    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(256), nullable=False)  # 存储加密后的哈希值
    real_name = db.Column(db.String(50))
    phone = db.Column(db.String(20))
    role = db.Column(db.Integer, default=1)  # 0:管理员, 1:普通用户
    create_time = db.Column(db.DateTime, default=datetime.datetime.now)


class FactoryInfo(db.Model):
    """厂房信息表"""
    __tablename__ = 'factory_info'

    factory_id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100))
    area = db.Column(db.Float)
    price_per_month = db.Column(db.Float)
    address = db.Column(db.String(255))
    description = db.Column(db.Text)
    images = db.Column(db.Text)  # 图片链接，逗号分隔
    status = db.Column(db.Integer, default=0)  # 0:空闲, 1:已租

    # 工业参数
    floor_height = db.Column(db.Float)  # 层高
    power_supply = db.Column(db.String(50))  # 配电
    floor_load = db.Column(db.Float)  # 承重
    structure = db.Column(db.String(50))  # 结构
    tags = db.Column(db.String(255))  # 标签
    create_time = db.Column(db.DateTime, default=datetime.datetime.now)


class Contract(db.Model):
    """租赁合同表"""
    __tablename__ = 'contract'

    contract_id = db.Column(db.Integer, primary_key=True)
    contract_no = db.Column(db.String(50), unique=True)

    # 外键关联
    user_id = db.Column(db.Integer, db.ForeignKey('sys_user.user_id'))
    factory_id = db.Column(db.Integer, db.ForeignKey('factory_info.factory_id'))

    # 基础信息
    start_date = db.Column(db.String(20))
    end_date = db.Column(db.String(20))
    total_price = db.Column(db.Float)
    status = db.Column(db.Integer, default=0)  # 0:待审核/进行中, 1:已完成, etc.
    create_time = db.Column(db.DateTime, default=datetime.datetime.now)

    # 合同主体详情
    party_a = db.Column(db.String(100))
    party_a_address = db.Column(db.String(255))
    party_a_legal_rep = db.Column(db.String(50))
    party_a_phone = db.Column(db.String(20))

    party_b = db.Column(db.String(100))
    party_b_address = db.Column(db.String(255))
    party_b_legal_rep = db.Column(db.String(50))
    party_b_phone = db.Column(db.String(20))

    # 合同条款细节
    content = db.Column(db.Text)
    purpose = db.Column(db.String(100))
    deposit = db.Column(db.Float)
    payment_cycle = db.Column(db.String(50))

    # 关系映射
    user = db.relationship('User', backref='contracts')
    factory = db.relationship('FactoryInfo', backref='contracts')


class Comment(db.Model):
    """厂房评价表"""
    __tablename__ = 'factory_comment'

    comment_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('sys_user.user_id'))
    factory_id = db.Column(db.Integer, db.ForeignKey('factory_info.factory_id'))

    content = db.Column(db.String(500))
    score = db.Column(db.Integer)
    is_audit = db.Column(db.Integer, default=0)  # 0:未审核, 1:已审核
    create_time = db.Column(db.DateTime, default=datetime.datetime.now)

    user = db.relationship('User', backref='comments')
    factory = db.relationship('FactoryInfo', backref='comments')


class Announcement(db.Model):
    """系统公告表"""
    __tablename__ = 'sys_notice'

    notice_id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    content = db.Column(db.Text, nullable=False)
    create_time = db.Column(db.DateTime, default=datetime.datetime.now)


class Payment(db.Model):
    """支付记录表"""
    __tablename__ = 'sys_payment'

    payment_id = db.Column(db.Integer, primary_key=True)
    contract_id = db.Column(db.Integer, db.ForeignKey('contract.contract_id'))

    amount = db.Column(db.Float)
    pay_method = db.Column(db.String(20), default='支付宝')
    pay_time = db.Column(db.DateTime, default=datetime.datetime.now)

    contract = db.relationship('Contract', backref='payments')


class Collection(db.Model):
    """用户收藏表"""
    __tablename__ = 'sys_collection'

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('sys_user.user_id'), nullable=False)
    factory_id = db.Column(db.Integer, db.ForeignKey('factory_info.factory_id'), nullable=False)
    create_time = db.Column(db.DateTime, default=datetime.datetime.now)