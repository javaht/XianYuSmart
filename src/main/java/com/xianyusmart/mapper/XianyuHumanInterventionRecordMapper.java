package com.xianyusmart.mapper;

import com.xianyusmart.entity.XianyuHumanInterventionRecord;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface XianyuHumanInterventionRecordMapper {

    @Insert("INSERT INTO xianyu_human_intervention_record (xianyu_account_id, xy_goods_id, s_id, end_time) " +
            "VALUES (#{xianyuAccountId}, #{xyGoodsId}, #{sId}, #{endTime}) " +
            "ON CONFLICT(xianyu_account_id, s_id) DO UPDATE SET " +
            "end_time = excluded.end_time, " +
            "xy_goods_id = COALESCE(excluded.xy_goods_id, xy_goods_id)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(XianyuHumanInterventionRecord record);

    @Select("SELECT * FROM xianyu_human_intervention_record WHERE xianyu_account_id = #{accountId} AND s_id = #{sId} AND end_time > datetime('now') LIMIT 1")
    XianyuHumanInterventionRecord findActiveByAccountAndSId(@Param("accountId") Long accountId,
                                                             @Param("sId") String sId);

    @Select("SELECT COUNT(*) FROM xianyu_human_intervention_record WHERE end_time > datetime('now')")
    int countActive();

    @Delete("DELETE FROM xianyu_human_intervention_record WHERE end_time < datetime('now')")
    int cleanExpired();
}
