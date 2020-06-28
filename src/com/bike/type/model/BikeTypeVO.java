package com.bike.type.model;

import java.io.Serializable;

public class BikeTypeVO implements Serializable {
	
	public BikeTypeVO() {
		
	};
	
	private String sq_bike_type_id;
	private String bike_type_name;
	private String bike_title;
	private String bike_description;
	private byte[] bike_photo;
	private Integer bike_daily_price;
	private Integer bike_hourly_price;
	
	public String getSq_bike_type_id() {
		return sq_bike_type_id;
	}
	public void setSq_bike_type_id(String sq_bike_type_id) {
		this.sq_bike_type_id = sq_bike_type_id;
	}
	public String getBike_type_name() {
		return bike_type_name;
	}
	public void setBike_type_name(String bike_type_name) {
		this.bike_type_name = bike_type_name;
	}
	public String getBike_title() {
		return bike_title;
	}
	public void setBike_title(String bike_title) {
		this.bike_title = bike_title;
	}
	public String getBike_description() {
		return bike_description;
	}
	public void setBike_description(String bike_description) {
		this.bike_description = bike_description;
	}
	public byte[] getBike_photo() {
		return bike_photo;
	}
	public void setBike_photo(byte[] bike_photo) {
		this.bike_photo = bike_photo;
	}

	public Integer getBike_daily_price() {
		return bike_daily_price;
	}
	public void setBike_daily_price(Integer bike_daily_price) {
		this.bike_daily_price = bike_daily_price;
	}
	public Integer getBike_hourly_price() {
		return bike_hourly_price;
	}
	public void setBike_hourly_price(Integer bike_hourly_price) {
		this.bike_hourly_price = bike_hourly_price;
	}
	
	
	
}
