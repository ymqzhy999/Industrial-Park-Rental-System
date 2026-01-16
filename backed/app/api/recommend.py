import random
import pandas as pd
from flask import Blueprint, jsonify, request
from sqlalchemy import desc
from app.models import Collection, FactoryInfo
from app.extensions import db

try:
    from sklearn.metrics.pairwise import cosine_similarity

    HAS_ALGO_LIB = True
except ImportError:
    HAS_ALGO_LIB = False
    print("【警告】未安装 scikit-learn，推荐算法将降级为普通推荐")

recommend_bp = Blueprint('recommend', __name__, url_prefix='/api/recommend')


@recommend_bp.route('/list', methods=['GET'])
def recommend_factories():
    """获取推荐厂房列表 (协同过滤算法)"""
    user_id = request.args.get('userId', type=int, default=2)
    TOP_N = 4

    # 1. 降级检查
    if not HAS_ALGO_LIB:
        return get_fallback_recommendations(TOP_N, "系统缺少依赖库，已切换为最新推荐")

    all_records = Collection.query.all()
    if not all_records:
        return get_fallback_recommendations(TOP_N, "暂无任何收藏数据，已切换为最新推荐")

    try:
        # 2. 算法核心
        data = [{'user_id': r.user_id, 'factory_id': r.factory_id, 'rating': 1} for r in all_records]
        df = pd.DataFrame(data)

        if user_id not in df['user_id'].values:
            return get_fallback_recommendations(TOP_N, "您还没有收藏记录，为您推荐最新厂房")

        user_item_matrix = df.pivot_table(index='user_id', columns='factory_id', values='rating').fillna(0)
        user_similarity = cosine_similarity(user_item_matrix)
        user_sim_df = pd.DataFrame(user_similarity, index=user_item_matrix.index, columns=user_item_matrix.index)

        if user_id not in user_sim_df.index:
            return get_fallback_recommendations(TOP_N, "用户索引缺失")

        # 取最相似的5个邻居
        similar_users = user_sim_df[user_id].sort_values(ascending=False)[1:6]

        recommend_scores = {}
        my_collected_factories = set(user_item_matrix.loc[user_id][user_item_matrix.loc[user_id] == 1].index)

        for sim_user_id, similarity_score in similar_users.items():
            if similarity_score <= 0: continue

            sim_user_collections = user_item_matrix.loc[sim_user_id]
            sim_user_factory_ids = sim_user_collections[sim_user_collections == 1].index

            for fid in sim_user_factory_ids:
                if fid not in my_collected_factories:
                    recommend_scores[fid] = recommend_scores.get(fid, 0) + similarity_score

        if not recommend_scores:
            return get_fallback_recommendations(TOP_N, "暂无个性化推荐，为您展示热门厂房")

        # 3. 排序与随机化
        sorted_ids = [x[0] for x in sorted(recommend_scores.items(), key=lambda x: x[1], reverse=True)]
        final_ids = sorted_ids[:TOP_N]

        if len(final_ids) > 1:
            random.shuffle(final_ids)

        return get_factories_by_ids(final_ids, f"基于协同过滤算法推荐 (命中{len(final_ids)}个)")

    except Exception as e:
        print(f"推荐算法异常: {e}")
        return get_fallback_recommendations(TOP_N, "算法计算异常，已切换为最新推荐")


def get_fallback_recommendations(limit, debug_msg=""):
    """兜底推荐：返回最新发布的厂房"""
    factories = FactoryInfo.query.order_by(desc(FactoryInfo.create_time)).limit(limit).all()
    data = format_factory_list(factories)
    return jsonify({
        'code': 200,
        'data': data,
        'msg': debug_msg,
        'type': 'fallback'
    })


def get_factories_by_ids(ids, debug_msg=""):
    """根据 ID 列表查询并返回"""
    factories = FactoryInfo.query.filter(FactoryInfo.factory_id.in_(ids)).all()
    f_map = {f.factory_id: f for f in factories}

    sorted_factories = []
    for fid in ids:
        if fid in f_map:
            sorted_factories.append(f_map[fid])

    data = format_factory_list(sorted_factories)
    return jsonify({
        'code': 200,
        'data': data,
        'msg': debug_msg,
        'type': 'collaborative'
    })


def format_factory_list(factories):
    """通用格式化函数"""
    res = []
    for f in factories:
        res.append({
            'id': f.factory_id,
            'title': f.title,
            'price': f.price_per_month,
            'area': f.area,
            'address': f.address,
            'image': f.images.split(',')[0] if f.images else '',
            'tags': f.tags.split(',') if f.tags else []
        })
    return res