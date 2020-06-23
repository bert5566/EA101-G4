<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.actreport.model.*"%>
<%-- 此頁暫練習採用 Script 的寫法取值 --%>

<%
  ActReportVO actreportVO = (ActReportVO) request.getAttribute("actreportVO");
%>

<html>
<head>
<title>活動檢舉資料 - listOneActReport.jsp</title>

<style>
  table#table-1 {
	background-color: #CCCCFF;
    border: 2px solid black;
    text-align: center;
  }
  table#table-1 h4 {
    color: red;
    display: block;
    margin-bottom: 1px;
  }
  h4 {
    color: blue;
    display: inline;
  }
</style>

<style>
  table {
	width: 100%;
	background-color: white;
	margin-top: 5px;
	margin-bottom: 5px;
  }
  table, th, td {
    border: 1px solid #CCCCFF;
  }
  th, td {
    padding: 5px;
    text-align: center;
  }
  .table1 {
  	table-layout:fixed;
  	word-break:break-all;
  }
  
  .des {
  	overflow:hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
  }
</style>

</head>
<body bgcolor='white'>

<h4>此頁暫練習採用 Script 的寫法取值:</h4>
<table id="table-1">
	<tr><td>
		 <h3>活動檢舉資料 - listOneActReport.jsp</h3>
		 <h4><a href="<%=request.getContextPath()%>/back-end/reportActivity/select_page.jsp"><img src="<%=request.getContextPath()%>/back-end/activity/images/back1.gif" width="100" height="32" border="0">回首頁</a></h4>
	</td></tr>
</table>

<table class="table1">
	<tr>
		<th>活動檢舉編號</th>
		<th>活動編號</th>
		<th>會員編號</th>
		<th>檢舉原因</th>
		<th>檢舉狀態</th>
		<th>修改狀態</th>
		<th>備註</th>
	</tr>
	<tr>
		<td><%=actreportVO.getSq_activityreport_id()%></td>
		<td><%=actreportVO.getSq_activity_id()%></td>
		<td><%=actreportVO.getSq_member_id()%></td>
		<td class="des"><%=actreportVO.getReport_reason()%></td>
		<td><%=actreportVO.getReport_status()%></td>
		<td>
			<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/act/ActReportServlet.do" style="margin-bottom: 0px;">
			<input type="submit" value="修改">
			<input type="hidden" name="sq_activityreport_id"  value="${actreportVO.sq_activityreport_id}">
			<input type="hidden" name="action"	value="getOne_For_Update"></FORM>
		</td>
		<td>
			<p>0.檢舉未處理</p>
			<p>1.檢舉已處理</p>
		</td>
	</tr>
</table>

</body>
</html>