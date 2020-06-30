package com.route.model;

import java.sql.Timestamp;
import java.util.List;
import java.util.Set;
import com.route.model.RouteVO;

public class RouteService {
	
	private RouteDAO_interface dao;

	public RouteService() {
		dao = new RouteJDBCDAO();
	}
	public List<RouteVO> getAll(){
		return dao.getAll();
	}
	public RouteVO getOneRoute(String sqRouteId) {
		return dao.findByPrimaryKey(sqRouteId);
	}
	public List<RouteVO> getAreaByStartArea(String startArea){
		return dao.getAreaByStartArea(startArea);
	}
	public Set<RouteVO> getRouteByMemId (String sqMemberId) {
		return dao.getRouteByMemId(sqMemberId);
	}
	public void deleteRoute(String sqRouteId) {
		dao.delete(sqRouteId);
	}
	public RouteVO insert(String sqMemberId, String sqStaffId, String routeName, Double distance, String country, String startArea, 
			String endArea, byte[] routeImage, String routeIntroduction, Timestamp insertTimestamp, Timestamp updateTimestamp, 
			String modifyId, Integer checkFlag, Integer addRoute) {
		RouteVO routeVO = new RouteVO();
		routeVO.setSqMemberId(sqMemberId);
		routeVO.setSqStaffId(sqStaffId);
		routeVO.setRouteName(routeName);
		routeVO.setDistance(distance);
		routeVO.setCountry(country);
		routeVO.setStartArea(startArea);
		routeVO.setEndArea(endArea);
		routeVO.setRouteImage(routeImage);
		routeVO.setRouteIntroduction(routeIntroduction);
		routeVO.setInsertTimestamp(insertTimestamp);
		routeVO.setUpdateTimestamp(updateTimestamp);
		routeVO.setModifyId(modifyId);
		routeVO.setCheckFlag(checkFlag);
		routeVO.setAddRoute(addRoute);
		dao.insert(routeVO);
		return routeVO;
	}
	public RouteVO updateByMem (String routeName, Double distance, String country, String startArea, 
			String endArea, byte[] routeImage, String routeIntroduction) {
		RouteVO routeVO = new RouteVO();

		routeVO.setRouteName(routeName);
		routeVO.setDistance(distance);
		routeVO.setCountry(country);
		routeVO.setStartArea(startArea);
		routeVO.setEndArea(endArea);
		routeVO.setRouteImage(routeImage);
		routeVO.setRouteIntroduction(routeIntroduction);
		dao.updateByMem(routeVO);
		return routeVO;
	}
	public RouteVO updateByStaf (String routeName, Double distance, String country, String startArea, 
			String endArea, byte[] routeImage, String routeIntroduction, Timestamp insertTimestamp, 
			Integer checkFlag, Integer addRoute) {
		RouteVO routeVO = new RouteVO();
		routeVO.setRouteName(routeName);
		routeVO.setDistance(distance);
		routeVO.setCountry(country);
		routeVO.setStartArea(startArea);
		routeVO.setEndArea(endArea);
		routeVO.setRouteImage(routeImage);
		routeVO.setRouteIntroduction(routeIntroduction);
		routeVO.setInsertTimestamp(insertTimestamp);
		routeVO.setCheckFlag(checkFlag);
		routeVO.setAddRoute(addRoute);
		dao.updateByStaf(routeVO);
		return routeVO;
	}

}