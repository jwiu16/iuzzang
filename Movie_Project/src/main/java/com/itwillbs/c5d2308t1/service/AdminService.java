package com.itwillbs.c5d2308t1.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.c5d2308t1.mapper.AdminMapper;
import com.itwillbs.c5d2308t1.vo.CsVO;
import com.itwillbs.c5d2308t1.vo.EventsVO;
import com.itwillbs.c5d2308t1.vo.MemberVO;
import com.itwillbs.c5d2308t1.vo.MoviesVO;
import com.itwillbs.c5d2308t1.vo.PageDTO;
import com.itwillbs.c5d2308t1.vo.PlayVO;
import com.itwillbs.c5d2308t1.vo.RefundVO;
import com.itwillbs.c5d2308t1.vo.ReviewsVO;

@Service
public class AdminService {

	@Autowired
	AdminMapper mapper;
	
	
	// ================ 영화 관리 게시판 ================
	
	// 영화 DB 등록
	public int registMovie(Map<String, Object> map) {
		return mapper.insertMovies(map);
	}
	
	// 영화 DB 수정
	public int modifyMovie(MoviesVO movie) {
		return mapper.updateMovies(movie);
	}
	
	// 영화 DB 삭제
	public int deleteMovie(MoviesVO movie) {
		return mapper.deleteMovies(movie);
	}
	
	// 하나의 영화 정보 조회
	public MoviesVO getMovie(MoviesVO movie) {
		return mapper.selectMovie(movie);
	}
	
	// 페이징 처리를 위한 게시물 개수 조회 작업 요청
	public int getMovieListCount(String searchKeyword, String sortMovie) {
		return mapper.selectMovieListCount(searchKeyword, sortMovie);
	}
	
	// 한 페이지에 표시할 영화 목록 조회 작업 요청
	public List<MoviesVO> getMovieList(String searchKeyword, String sortMovie, PageDTO page) {
		return mapper.selectMovieList(searchKeyword,sortMovie, page);
	}
	
	// ================ 분실물 게시판 ================
	// 분실물 문의 관리 게시판 조회 작업 요청
	public List<HashMap<String, Object>> getLostnfoundList(PageDTO page, String searchValue) {
		return mapper.selectLostnfoundList(page, searchValue);
	}

	// 분실문 문의 관리 게시판 상세 조회 작업 요청
	public HashMap<String, Object> getlostnfound(CsVO cs) {
		return mapper.selectLostnfound(cs);
	}
	
	// 분실물 문의 답변 등록 작업 요청
	public int LostnfoundReply(CsVO cs) {
		return mapper.updateLnfReply(cs);
	}
	
	// 분실물 문의 답변 삭제 작업 요청
	public int lostnfoundDlt(CsVO cs) {
		return mapper.updateLnfDlt(cs);
	}
	
	// 분실물 페이징 처리를 위한 게시물 개수 조회 작업 요청
	public int getlostnfoundListCount(String searchValue) {
		return mapper.selectLostnfoundListCount(searchValue);
	}
	
	
	// ================ 회원 관리 게시판 ================
	// 회원 관리 게시판 페이징 처리를 위한 게시물 개수 조회 작업 요청
	public int getMemberListCount(String searchType, String searchKeyword) {
		return mapper.selectMemberListCount(searchType, searchKeyword);
	}

	// 회원 관리 게시판 한 페이지에 표시할 회원 조회
	public List<MemberVO> getMemberList(String searchType, String searchKeyword, PageDTO page) {
		return mapper.selectMemberList(searchType, searchKeyword, page);
	}
	// 회원 한명의 정보 조회
	public MemberVO getMember(MemberVO member) {
		return mapper.selectMember(member);
	}

	// 회원 정보 수정 및 탈퇴 작업
	public int memberModOrDlt(MemberVO member, String newPasswd) {
		return mapper.updatememberModOrDlt(member, newPasswd);
	}
	
	// ============ 자주묻는질문관리, 공지사항관리 게시판 =================
	
	// 자주묻는질문 공지사항 목록 조회 요청 및 페이징
	public List<HashMap<String, Object>> getFaqList(CsVO cs, int startRow, int listLimit, String searchValue) {
		return mapper.selectFaqList(cs, startRow, listLimit, searchValue);
	}	
	public List<HashMap<String, Object>> getNoticeList(CsVO cs, int startRow, int listLimit, String searchValue) {
		return mapper.selectNoticeList(cs, startRow, listLimit, searchValue);
	}
	
	// 관리자페이지 게시판 항목별 목록 갯수 조회 요청
	public int getFaqListCount(CsVO cs, String searchValue) {
		return mapper.selectFaqCount(cs, searchValue);
	}
	public int getNoticeListCount(CsVO cs, String searchValue) {
		return mapper.selectNoticeCount(cs, searchValue);
	}
	
	// 관리자페이지 자주묻는질문 상세페이지 보기
	public HashMap<String, Object> boardfaqDetailPage(CsVO cs) {
		return mapper.selectFaqDetailPage(cs);
	}
	
	// 관리자페이지 게시글 등록
	public int registBoard(CsVO cs) {
		return mapper.insertBoard(cs);
	}
	
	// 관리자페이지 게시글 수정
	public int updateBoard(CsVO cs) {
		return mapper.updateBoard(cs);
	}
	
	// 자주묻는질문 항목별로 목록 개수 조회 요청
	public int getFaqDetailCount(CsVO cs, String buttonName) {
		return mapper.selectFaqDetailCount(cs, buttonName);
	}
	
	// 관리자페이지 공지사항 상세페이지 보기
	public HashMap<String, Object> boardNoticeDetailPage(CsVO cs) {
		return mapper.selectNoticeDetailPage(cs);
	}
	
	public int removeBoard(HashMap<String, Object> board) {
		return mapper.deleteBoard(board);
	}
	

	// ****************** 1대1문의 게시판 *********************
	// 1대1문의 관리 게시판 글 목록 조회 작업 요청
	public List<CsVO> getOneOnOnePosts(PageDTO page, String searchType, String searchKeyword) {
		return mapper.selectOneOnOneList(page, searchType, searchKeyword);
	}

	// 1대1문의 페이징 처리를 위한 게시물 개수 조회 작업 요청
	public int getOneOnOneListCount(String searchType, String searchKeyword) {
		return mapper.selectOneOnOneListCount(searchType, searchKeyword);
	}

//	// 1대1문의 관리 게시판 상세 조회 작업 요청
	public HashMap<String, Object> getOneOnOnePostById(CsVO cs) {
		return mapper.selectOneOnOne(cs);
	}

	// 1대1문의 답변 등록, 수정 작업 요청
	public int writeOneOnOneReply(CsVO cs) {
		return mapper.updateOneOnOneReply(cs);
	}
	
	// 1대1문의 답변 삭제 작업 요청
	public int removeOneOnOneReply(CsVO cs) {
		return mapper.deleteOneOnOneReply(cs);
	}



	
	// ****************** 상영스케쥴 관리 게시판 *********************
	// 1) 상영 일정 메인 페이지
	// 상영 일정 메인페이지로 이동 시 기본 정보 조회 작업 요청
	public List<Map<String, Object>> getMainScheduleInfo() {
		return mapper.selectMainScheduleInfo();
	}
	
	
	
	// 상영 일정 메인 페이지 상영일정 조회 작업 요청 
	public List<Map<String, Object>> getScheduleInfo(Map<String, String> map) {
		return mapper.selectScheduleInfo(map);
	}

	// 2) 상영 일정 관리 페이지
	// 무한스크롤을 위한 전체 게시글 갯수 조회
	public int getMovieScheduleListCount() {
		return mapper.selectMovieScheduleListCount();
	}
	
	// 상영 일정 관리 페이지로 이동 시 등록된 상영 일정 조회 작업 요청
	public List<HashMap<String, Object>> getPlayRegistList(PageDTO page) {
		return mapper.selectPlayListAll(page);
	}

	// 지점명에 따른 상영관 조회 작업 요청
	public List<HashMap<String, Object>> getRoomList(String theater_id) {
		return mapper.selectRoom(theater_id);
	}
	
	// 상영중인 영화 조회 작업 요청
	public List<HashMap<String, Object>> getPlayingList() {
		return mapper.selectPlayingMovie();
	}

	// 선택한 영화 정보 요청
	public HashMap<String, Object> getMovieInfo(String movie_id) {
		return mapper.selectMovieInfo(movie_id);
	}
	
	// 상영시간 정보 불러오기
	public List<HashMap<String, Object>> playTimeInfo(PlayVO play) {
		return mapper.selectPlayTimeInfo(play);
	}

	// 상영 일정 등록 요청
	public int registPlay(PlayVO play) {
		return mapper.insertPlay(play);
	}

	// 상영 일정 삭제 요청
	public int removePlay(int play_id) {
		return mapper.deletePlay(play_id);
	}

	// 상영 일정 수정 요청
//	@Transactional
	public int modifySchedule(PlayVO play) {
//		String playId = formData.get("play_id");
//        String theaterId = formData.get("theater_id");
//        String roomId = formData.get("room_id");
//        String movieId = formData.get("movie_title");
//        String playDate = formData.get("play_date");
//        String playStartTime = formData.get("play_start_time");
//        String playEndTime = formData.get("play_end_time");
//        mapper.deleteRef(movieId);
//        return mapper.updateSchedule(playId, theaterId, roomId, movieId, playDate, playStartTime, playEndTime);
		return mapper.updateSchedule(play);

	}
	
	// 상영일정 수정 버튼 클릭 시 기존 상영일정 조회 작업
	public Map<String, Object> getpreviousScheduleInfo(String previousTrId) {
		return mapper.selectpreviousScheduleInfo(previousTrId);
	}
	
	
	// ========================================================================

	//리뷰 조회
	public List<ReviewsVO> getReviewLiset(ReviewsVO review) {
		return mapper.selectReviewList(review);
	}

	
	// 관리자 예매내역을 위한 페이징 처리 
	public int getReserveListCount(String searchKeyword) {
		return mapper.selectReserveListCount(searchKeyword);
	}
	// 관리자 한 페이지에 표시할 예매내역 검색을 위한 처리
	public List<HashMap<String, String>> getReserveList(String searchKeyword, PageDTO page) {
		return mapper.selectReserveList(searchKeyword, page);
	}
	//예매취소내역 조회
	public int getCancleReserveListCount(String searchKeyword) {
		return mapper.selectCancleReserveListCount(searchKeyword);
	}
	//한 페이지에 불러올 예매취소내역 조회
	public List<HashMap<String, String>> getCancleReserveList(String searchKeyword, PageDTO page) {
		return mapper.selectCancleReserveList(searchKeyword, page);
	}
	//리뷰 상세정보
	public List<ReviewsVO> getReviewDetailList(ReviewsVO review) {
		return mapper.selectReviewDlt(review);
	}


	// ****************** 관리자 메인 차트 *********************

	// (차트)일일 가입 회원수 알아보기
	public List<HashMap<String, Object>> getJoinCount() {
		return mapper.selectJoinCount();
	}
	
	// (차트)일별 매출 알아보기
	public List<HashMap<String, Object>> getRevenue() {
		return mapper.selectRevenue();
	}
	
	// (차트)영화 예매 비율 알아보기
	public List<Map<String, String>> getMovieChart() {
		return mapper.selectMovieChart();
	}
	
	// (차트)상품 판매량 알아보기
	public List<Map<String, String>> productCount() {
		return mapper.selectProducts();
	}
	// ==================상품 결제 관리 게시판 ==================================
	// 결제 리스트 조회를 위한 리스트 카운트 조회
	public int getPaymentListCount(String searchType, String searchKeyword) {
		return mapper.selectPaymentListCount(searchType, searchKeyword);
	}
	
	// 결제 리스트 조회 요청 작업
	public List<RefundVO> getPaymentList(String searchType, String searchKeyword, PageDTO page) {
		return mapper.selectPaymentList(searchType, searchKeyword, page);
	}
	
	// 결제관리 상세페이지 요청 작업
	public RefundVO registPaymentDetail(Map<String, String> map) {
		return mapper.selectPaymentDetail(map);
	}
	
	// 결제관리 상세페이지 결제취소 요청 작업
	public int getPaymentBuyCancel(Map<String, String> map) {
		return mapper.updatePaymentBuyCancel(map);
	}
	
	// ================== 이벤트 관리 게시판 ==================================
	// 이벤트 등록 작업
	public int registEvent(EventsVO event) {
		return mapper.insertEvent(event);
	}

	// 이벤트 게시판 페이징 처리
	public int getEventListCount(String searchKeyword) {
		return mapper.selectEventListCount(searchKeyword);
	}

	// 이벤트 게시판 목록 조회
	public List<EventsVO> getEventList(String searchKeyword, PageDTO page) {
		return mapper.selectEventList(searchKeyword, page);
	}

	// 이벤트 상세 페이지를 위한 이벤트 조회
	public EventsVO getEvent(EventsVO event) {
		return mapper.selectEvent(event);
	}

	// 이벤트 삭제 작업
	public int deleteEvent(EventsVO event) {
		return mapper.deleteEvent(event);
	}

	// 이벤트 수정 - 파일 삭제
	public int removiEventFile(EventsVO event) {
		return mapper.updateEventFile(event);
	}

	// 이벤트 수정
	public int modifyEvent(EventsVO event) {
		return mapper.updateEvent(event);
	}

	public int getReviewCount(ReviewsVO review) {
		
		return mapper.selectReviewCount(review);
	}

	public List<ReviewsVO> getAdminReviewList(PageDTO page, ReviewsVO review) {
		
		return mapper.selectAdminReviewList(page,review);
	}
}

















