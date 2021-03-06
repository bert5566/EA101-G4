package com.staff.model;

import java.sql.Blob;
import java.sql.Date;
import java.util.List;

public class StaffService {
	private StaffDAO_interface dao;
	public StaffService() {
		dao = new StaffDAO();
	}
	
	//findByAccount
	public StaffVO findByAccount(String staff_account) {
		return dao.findByAccount(staff_account);
	}
	
	//staff status
	public String fine_status_name(Integer staff_status) {
		String name = null;
		switch(staff_status) {
		case 0 :
			name="在職";
			break;
		case 1 :
			name="離職";
			break;
		}
		return name;
	}
	

	public void addStaff(StaffVO staffVO) {
		dao.insert(staffVO);
	}

	public StaffVO updateStaff(String sq_staff_id,Integer sf_status,String sf_account,String sf_password,String sf_name) {
		StaffVO staffVO = new StaffVO();
		staffVO.setSq_staff_id(sq_staff_id);
		staffVO.setSf_status(sf_status);
		staffVO.setSf_account(sf_account);
		staffVO.setSf_password(sf_password);
		staffVO.setSf_name(sf_name);
		dao.update(staffVO);
		return staffVO;
	}

	public void updateStaff(StaffVO staffVO) {
		dao.update(staffVO);
	}

	public void deleteStaff(String sq_staff_id) {
		dao.delete(sq_staff_id);
	}


	public List<StaffVO> getAll() {
		return dao.getAll();
	}
	public StaffVO findByPrimaryKey(String sq_staff_id) {
		return dao.findByPrimaryKey(sq_staff_id);
	}
}
