package com.actreport.model;

import java.util.*;


public interface ActReportDAO_interface {
	public void insert(ActReportVO actreportVO); //前台新增檢舉
    public void update(ActReportVO actreportVO);//後台修改檢舉處理狀態
    public ActReportVO findByPrimaryKey(String actreportid);//後台查單一
    public List<ActReportVO> findByMemberId(String memberid); //前台會員查他們自己的檢舉
    public List<ActReportVO> getAll(); //後台查全部
    public int findGpStatusByPK(String activityid); //前台頁面篩選檢舉已處理時會被屏蔽
    //萬用複合查詢(傳入參數型態Map)(回傳 List)
    //public Set<ActVO> getEmpsByDeptno(Integer actid);
}
