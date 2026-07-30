package com.xianyusmart.mapper;

import com.xianyusmart.entity.XianyuGoodsAutoReplyRecord;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 商品自动回复记录Mapper
 */
@Mapper
public interface XianyuGoodsAutoReplyRecordMapper {
    
    /**
     * 插入记录
     */
    @Insert("INSERT INTO xianyu_goods_auto_reply_record (xianyu_account_id, xianyu_goods_id, xy_goods_id, s_id, pnm_id, buyer_user_id, buyer_user_name, buyer_message, reply_content, reply_type, matched_keyword, trigger_context, state, scheduled_time) " +
            "VALUES (#{xianyuAccountId}, #{xianyuGoodsId}, #{xyGoodsId}, #{sId}, #{pnmId}, #{buyerUserId}, #{buyerUserName}, #{buyerMessage}, #{replyContent}, COALESCE(#{replyType}, 1), #{matchedKeyword}, #{triggerContext}, #{state}, #{scheduledTime}) " +
            "ON CONFLICT(xianyu_account_id, s_id, pnm_id) DO UPDATE SET " +
            "xianyu_goods_id = excluded.xianyu_goods_id, " +
            "xy_goods_id = excluded.xy_goods_id, " +
            "buyer_user_id = excluded.buyer_user_id, " +
            "buyer_user_name = excluded.buyer_user_name, " +
            "buyer_message = excluded.buyer_message, " +
            "reply_content = excluded.reply_content, " +
            "reply_type = excluded.reply_type, " +
            "matched_keyword = excluded.matched_keyword, " +
            "trigger_context = excluded.trigger_context, " +
            "state = excluded.state, " +
            "scheduled_time = excluded.scheduled_time")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(XianyuGoodsAutoReplyRecord record);
    
    /**
     * 更新记录状态和回复内容
     */
    @Update("UPDATE xianyu_goods_auto_reply_record SET state = #{state}, reply_content = #{replyContent}, " +
            "lease_owner = NULL, lease_expire_time = NULL, " +
            "exception_revision = exception_revision + CASE WHEN #{state} = -1 THEN 1 ELSE 0 END WHERE id = #{id}")
    int updateStateAndContent(@Param("id") Long id, @Param("state") Integer state, @Param("replyContent") String replyContent);
    
    /**
     * 更新触发上下文
     */
    @Update("UPDATE xianyu_goods_auto_reply_record SET trigger_context = #{triggerContext} WHERE id = #{id}")
    int updateTriggerContext(@Param("id") Long id, @Param("triggerContext") String triggerContext);
    
    /**
     * 根据账号ID查询记录
     */
    @Select("SELECT * FROM xianyu_goods_auto_reply_record WHERE xianyu_account_id = #{accountId} ORDER BY create_time DESC")
    List<XianyuGoodsAutoReplyRecord> selectByAccountId(@Param("accountId") Long accountId);
    
    /**
     * 根据账号ID和会话ID查询最新记录
     */
    @Select("SELECT * FROM xianyu_goods_auto_reply_record WHERE xianyu_account_id = #{accountId} AND s_id = #{sId} ORDER BY create_time DESC LIMIT 1")
    XianyuGoodsAutoReplyRecord selectLatestByAccountIdAndSId(@Param("accountId") Long accountId, @Param("sId") String sId);

    @Select("SELECT * FROM xianyu_goods_auto_reply_record WHERE id = #{id}")
    XianyuGoodsAutoReplyRecord selectById(@Param("id") Long id);

    @Select("SELECT * FROM xianyu_goods_auto_reply_record WHERE " +
            "(state = 0 AND scheduled_time <= datetime('now') AND (next_retry_time IS NULL OR next_retry_time <= datetime('now'))) " +
            "OR (state = 2 AND lease_expire_time < datetime('now')) ORDER BY scheduled_time ASC LIMIT #{limit}")
    List<XianyuGoodsAutoReplyRecord> findDue(@Param("limit") int limit);

    @Update("UPDATE xianyu_goods_auto_reply_record SET state = 2, lease_owner = #{workerId}, " +
            "lease_expire_time = datetime('now', '+' || #{leaseSeconds} || ' seconds'), attempt_count = attempt_count + 1 " +
            "WHERE id = #{id} AND (state = 0 OR (state = 2 AND lease_expire_time < datetime('now')))")
    int claim(@Param("id") Long id, @Param("workerId") String workerId, @Param("leaseSeconds") int leaseSeconds);

    @Update("UPDATE xianyu_goods_auto_reply_record SET state = -2, lease_owner = NULL, lease_expire_time = NULL " +
            "WHERE xianyu_account_id = #{accountId} AND s_id = #{sId} AND state = 0")
    int cancelPendingBySession(@Param("accountId") Long accountId, @Param("sId") String sId);

    @Update("UPDATE xianyu_goods_auto_reply_record SET state = -2, lease_owner = NULL, lease_expire_time = NULL WHERE id = #{id} AND state IN (0, 2)")
    int cancelById(@Param("id") Long id);

    @Select("SELECT COUNT(*) FROM xianyu_goods_auto_reply_record WHERE state IN (0, 2)")
    int countPending();
    
    /**
     * 根据账号ID删除记录
     */
    @Delete("DELETE FROM xianyu_goods_auto_reply_record WHERE xianyu_account_id = #{accountId}")
    int deleteByAccountId(@Param("accountId") Long accountId);
    
    /**
     * 根据账号ID和商品ID分页查询记录
     */
    @Select("SELECT * FROM xianyu_goods_auto_reply_record WHERE xianyu_account_id = #{accountId} AND xy_goods_id = #{xyGoodsId} ORDER BY create_time DESC LIMIT #{limit} OFFSET #{offset}")
    List<XianyuGoodsAutoReplyRecord> selectByAccountIdAndGoodsId(@Param("accountId") Long accountId, @Param("xyGoodsId") String xyGoodsId, @Param("limit") int limit, @Param("offset") int offset);
    
    /**
     * 根据账号ID和商品ID查询记录总数
     */
    @Select("SELECT COUNT(*) FROM xianyu_goods_auto_reply_record WHERE xianyu_account_id = #{accountId} AND xy_goods_id = #{xyGoodsId}")
    int countByAccountIdAndGoodsId(@Param("accountId") Long accountId, @Param("xyGoodsId") String xyGoodsId);

    @Select("SELECT COUNT(*) FROM xianyu_goods_auto_reply_record WHERE date(create_time) = date('now', '-1 day')")
    int countYesterdayAiReplies();

    @Select("SELECT COUNT(*) FROM xianyu_goods_auto_reply_record")
    int countAllReplies();

    @Select("SELECT COUNT(*) FROM xianyu_goods_auto_reply_record WHERE date(create_time) = #{date}")
    int countAiRepliesByDate(@Param("date") String date);
}
