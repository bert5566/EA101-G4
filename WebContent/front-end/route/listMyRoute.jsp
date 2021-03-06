<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="com.route.model.*"%>
<%@ page import="com.member.model.*"%>
<%-- 此頁練習採用 EL 的寫法取值 --%>

<%
	RouteService routeSvc = new RouteService();
	List<RouteVO> list = routeSvc.getAll();
	pageContext.setAttribute("list", list);
%>




<!DOCTYPE html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1, shrink-to-fit=no"
	name="viewport">
<title>所有路線資料 - listAllRou.jsp</title>
<link href="https://cdn.bootcss.com/sweetalert/1.1.3/sweetalert.min.css"
	rel="stylesheet">
<script src="https://cdn.bootcss.com/sweetalert/1.1.3/sweetalert.min.js"></script>
<style>
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

</head>

<body>
	<%@include file="/front-end/page-file/page-nav"%>

	<div class="container mt-3">
		<!-- Page Heading/Breadcrumbs -->
		<h1 class="mt-4 mb-3">我的路線</h1>
	</div>

	<div class="container mb-5 mt-3" >
		<div class="row">
			<table class="table text-center table-hover" >
				<thead>
					<tr>
				<th style="width: 90px;">路線編號</th>
				<th style="width: 150px;">路線名稱</th>
				<th style="width: 150px;">路線總距離(公里)</th>
				<th>路線圖片</th>
				<th>路線簡介</th>
				<th style="width: 120px;">路線細節</th>
				<th style="width: 70px;">審核狀態</th>
				<th style="width: 70px;">上架狀態</th>

			</tr>
				
				</thead>
				<tbody id="masterTbody"  style="height:188px;text-align:center;line-height:188px;">
			<c:forEach var="rouVO" items="${list}">

				<c:if test="${sessionScope.MemVO.sq_member_id == rouVO.sqMemberId }">
					<tr style="line-height: 22px;">
						<td style="padding : 0px; width: 85px; vertical-align: middle;">
							<div style="margin:0 auto; text-align: center;">${rouVO.sqRouteId}</div>
						</td>
						<td style="padding : 0px; valign:center; vertical-align: middle; ">
							<div style="margin:0 auto; text-align: center;">${rouVO.routeName}</div>
						</td>
						<td style="padding : 0px; vertical-align: middle;">
							<div style="margin:0 auto; text-align: center;">${rouVO.distance}</div>
						</td>
						<td style="padding : 0px; vertical-align: middle;"><img alt=""
							src="<%=request.getContextPath()%>/front-end/route/route.img?SQ_ROUTE_ID=${rouVO.sqRouteId}"
							style="width: 200px; height: 200px"></td>
						<td style="text-align: left; padding : 0px; valign:center; vertical-align: middle;">
							<div style="margin:0 auto; text-align: center;">${rouVO.routeIntroduction}</div>
						</td>
						<td style="padding : 0px; vertical-align: middle;">
							<div style="margin:0 auto; text-align: center;">
								<a
									href="<%=request.getContextPath()%>/front-end/route/route.do?sqRouteId=${rouVO.sqRouteId}&routeName=${rouVO.routeName}&action=getOneRoute_For_Display">查看路線細節</a>
							</div>
						</td>
						<td style="padding : 0px; vertical-align: middle;">
							<div style="margin:0 auto; text-align: center;">
								<c:if test="${rouVO.checkFlag == 0}">未審核</c:if>
								<c:if test="${rouVO.checkFlag == 1}">審核通過</c:if>
								<c:if test="${rouVO.checkFlag == 2}">審核未通過</c:if>
							</div>
						</td>

						<td style="padding : 0px; vertical-align: middle;">
							<div style="margin:0 auto; text-align: center;">
								<c:if test="${rouVO.addRoute == 0}">未上架</c:if>
								<c:if test="${rouVO.addRoute == 1}">已上架</c:if>
							</div>
						</td>
						
					</tr>
				</c:if>
			</c:forEach>
				</tbody>
			</table>
		</div>


	</div>

		<%@include file="/front-end/page-file/page-footer"%>
</body>
</html>