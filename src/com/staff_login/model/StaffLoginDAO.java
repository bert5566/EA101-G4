package com.staff_login.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.member_login.model.MemLoginVO;
import com.staff.model.StaffJDBCDAO;
import com.staff.model.StaffVO;

public class StaffLoginDAO implements StaffLoginDAO_interface {

	private static DataSource ds = null;
	static {
		try {
			Context ctx = new InitialContext();
			ds = (DataSource) ctx.lookup("java:comp/env/jdbc/EA101_G4");
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}

	private static final String CONTRAST = "select * from staff where sf_account=? ";

	@Override
	public StaffLoginVO getOneStaff(String sf_account) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StaffLoginVO staffLoginVO = null;

		try {
			con = ds.getConnection();
			pstmt = con.prepareStatement(CONTRAST);

			pstmt.setString(1, sf_account);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				staffLoginVO = new StaffLoginVO();

				staffLoginVO.setSq_staff_id(rs.getString("sq_staff_id"));
				staffLoginVO.setSf_status(rs.getInt("sf_status"));
				staffLoginVO.setSf_account(rs.getString("sf_account"));
				staffLoginVO.setSf_password(rs.getString("sf_password"));
				staffLoginVO.setSf_name(rs.getString("sf_name"));
				System.out.println("登入成功");
			}
		
		} catch (SQLException se) {
			throw new RuntimeException("A database error occured. " + se.getMessage());

		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException se) {
					se.printStackTrace(System.err);
				}
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException se) {
					se.printStackTrace(System.err);
				}
			}
			if (con != null) {
				try {
					con.close();
				} catch (Exception e) {
					e.printStackTrace(System.err);
				}
			}
		}

		return staffLoginVO;
	}

//	public static void main(String[] args) {
//
//		StaffLoginDAO dao = new StaffLoginDAO();
////		StaffLoginVO staffLoginVO = new StaffLoginVO();
//
//
//		StaffLoginVO staffLoginVO1 = dao.getOneStaff("STF-810010");
//		
//		System.out.print(staffLoginVO1.getSq_staff_id() + ",");
//		System.out.print(staffLoginVO1.getSf_status() + ",");
//		System.out.print(staffLoginVO1.getSf_account() + ",");
//		System.out.print(staffLoginVO1.getSf_password() + ",");
//		System.out.println(staffLoginVO1.getSf_name() + ",");
//
//		System.out.println("---------------------");
//
//	}	
}
