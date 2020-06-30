package com.waterStation.model;

import java.sql.Timestamp;
import java.util.List;

public class WaterStationService {
	private WaterStationDAO_interface dao;

	public WaterStationService() {
		dao = new WaterStationJDBCDAO();
	}

	public void insert(String stationName, String stationAddress, Double longitude,
			Double latitude, String country, String area, byte[] stationImage, String businessHours, Integer checkFlag, Integer addStation) {
		WaterStationVO wsVO = new WaterStationVO();
		wsVO.setStationName(stationName);
		wsVO.setStationAddress(stationAddress);
		wsVO.setLongitude(longitude);
		wsVO.setLatitude(latitude);
		wsVO.setCountry(country);
		wsVO.setArea(area);
		wsVO.setStationImage(stationImage);
		wsVO.setBusinessHours(businessHours);
		wsVO.setCheckFlag(checkFlag);
		wsVO.setAddStation(addStation);

		dao.insert(wsVO);

	}
	public WaterStationVO updateWs(String sqStationId, String stationName, String stationAddress, Double longitude,
			Double latitude, String country, String area, byte[] stationImage, String businessHours,
			Integer checkFlag, Integer addStation) {
		WaterStationVO wsVO = new WaterStationVO();
		wsVO.setStationName(stationName);
		wsVO.setStationAddress(stationAddress);
		wsVO.setLongitude(longitude);
		wsVO.setLatitude(latitude);
		wsVO.setCountry(country);
		wsVO.setArea(area);
		wsVO.setStationImage(stationImage);
		wsVO.setBusinessHours(businessHours);
		wsVO.setCheckFlag(checkFlag);
		wsVO.setAddStation(addStation);
		wsVO.setSqStationId(sqStationId);
		dao.update(wsVO);
		return wsVO;
	}
	
	public void deleteWs(String sqStationId) {
		dao.delete(sqStationId);
	}
	
	public List<WaterStationVO> getAll(){
		return dao.getAll();
	}
	
	public WaterStationVO getOneWs(String sqStationId) {
		return dao.findByPrimaryKey(sqStationId);
	}
}
