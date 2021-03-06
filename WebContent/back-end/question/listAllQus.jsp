<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="com.question.model.*"%>
<%-- 此頁練習採用 EL 的寫法取值 --%>

<%
	QuestionService qusSvc = new QuestionService();
    List<QuestionVO> list = qusSvc.getAll();
    pageContext.setAttribute("list",list);
%>
<%@include file="/back-end/backFrame/backHeader"%>
<title>所有員工資料 - listAllQus.jsp</title>

<style>
  table{
    table-layout : fixed;
}

table tbody tr td,table tbody tr th{
    white-space: nowrap;
    overflow: hidden; 
    text-overflow: ellipsis; 
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
</style>

<%@include file="/back-end/backFrame/backBody"%>
<div class="row" style="background-color: white;">
	<ul class="nav nav-tabs">
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/back-end/tips/listAllTips.jsp">
			<span>小叮嚀總覽</span></a>
		</li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/back-end/tips/addTips.jsp"><span>新增小叮嚀</span></a>
		</li>
		<li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/back-end/question/listAllQus.jsp">
		<span style="padding-bottom: 8px; border-bottom: 3px blue solid;">Q&A總覽</span></a>
		</li>
		<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/back-end/question/addQus.jsp"><span>新增Q&A</span></a>
		</li>
	</ul>
</div>
<%@include file="/back-end/backFrame/backNav"%>

<%-- 錯誤表列 --%>
<c:if test="${not empty errorMsgs}">
	<font style="color:red">請修正以下錯誤:</font>
	<ul>
		<c:forEach var="message" items="${errorMsgs}">
			<li style="color:red">${message}</li>
		</c:forEach>
	</ul>
</c:if>
<div class="container-fluid mt-3">
<table class="table text-center table-bordered table-striped table-hover">
<thead>
	<tr class="table-info">
		<th>問題編號</th>
		<th>問題標題</th>
		<th>問題回答</th>
		<th>修改</th>
		<th>刪除</th>
	</tr>
	</thead>
	<%@ include file="page1.file" %> 
	<c:forEach var="questionVo" items="${list}" begin="<%=pageIndex%>" end="<%=pageIndex+rowsPerPage-1%>">
		
		<tr>
			<td>${questionVo.sq_question_id}</td> 
			<td>${questionVo.question_title}</td>
			<td>${questionVo.question_description}</td>
			
			<td>
			  <FORM METHOD="post" ACTION="<%=request.getContextPath()%>/question/question.do" style="margin-bottom: 0px;">
			     <input type="submit" value="修改">
			     <input type="hidden" name="sq_question_id"  value="${questionVo.sq_question_id}">
			     <input type="hidden" name="action"	value="getOne_For_Update"></FORM>
			</td>
			<td>
			  <FORM METHOD="post" ACTION="<%=request.getContextPath()%>/question/question.do" style="margin-bottom: 0px;">
			     <input type="submit" value="刪除">
			     <input type="hidden" name="sq_question_id"  value="${questionVo.sq_question_id}">
			     <input type="hidden" name="action" value="delete"></FORM>
			</td>
		</tr>
	</c:forEach>
</table>
</div>
<%@ include file="page3.file" %>
<%@include file="/back-end/backFrame/backFooter"%>