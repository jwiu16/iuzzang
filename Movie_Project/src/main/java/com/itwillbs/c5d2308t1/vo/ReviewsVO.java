package com.itwillbs.c5d2308t1.vo;

import java.sql.Date;

import lombok.Data;
@Data
public class ReviewsVO {
		private int review_id; //리뷰코드
		private int review_rating; //리뷰평점
		private String review_content; //리뷰내용
		private Date review_date; //작성시간
		private String member_id; //회원 ID
		private String movie_title; //회원 ID
		private int movie_id; //영화코드
}
