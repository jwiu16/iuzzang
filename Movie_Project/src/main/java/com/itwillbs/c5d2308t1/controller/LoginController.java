package com.itwillbs.c5d2308t1.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.c5d2308t1.service.LoginService;
import com.itwillbs.c5d2308t1.service.ReserveService;
import com.itwillbs.c5d2308t1.vo.CsVO;
import com.itwillbs.c5d2308t1.vo.MemberVO;
import com.itwillbs.c5d2308t1.vo.NaverLoginVO;
import com.itwillbs.c5d2308t1.vo.PageCount;
import com.itwillbs.c5d2308t1.vo.PageDTO;
import com.itwillbs.c5d2308t1.vo.RefundVO;
import com.itwillbs.c5d2308t1.vo.ReviewsVO;
@Controller
public class LoginController {

	@Autowired
	private LoginService service;
	
	@Autowired
	private ReserveService reserve;
	
	 /* NaverLoginVO */
	private NaverLoginVO NaverLoginVO;
	
	@Autowired
    private void setNaverLoginVO(NaverLoginVO NaverLoginVO) {
        this.NaverLoginVO = NaverLoginVO;
    }
	

	@GetMapping("memberLogin") //메인화면에서 로그인 버튼 클릭시 이동
	public String memberLogin(HttpServletRequest request, HttpSession session, Model model) {
	    String sId = (String) session.getAttribute("sId");
	    if (sId != null) { // 세션아이디 있을경우 fail_back
	        model.addAttribute("msg", "이미 로그인되어 있습니다");
	        return "fail_back";
	    }	
		
		
		// "REFERER" 헤더는 현재 요청을 보내는 페이지의 URL을 가리킨다.
		String prevPage  = request.getHeader("REFERER");
		System.out.println("이전페이지는 어디인가요????? : " + prevPage);
		
		 /* 네이버아이디로 인증 URL을 생성하기 위하여 NaverLoginVO클래스의 getAuthorizationUrl메소드 호출 */
        String naverAuthUrl = NaverLoginVO.getAuthorizationUrl(session);
        
        System.out.println("네이버:" + naverAuthUrl);
        
        //네이버 
        model.addAttribute("url", naverAuthUrl);
		
		// 이전 페이지가 null이 아닐 경우 서블릿 주소만 잘라내서 세션에 저장한다.
		if(prevPage != null) {
			prevPage = prevPage.substring(prevPage.lastIndexOf("/") + 1);
			System.out.println("구분자로 잘라놓은 페이지를 보여주세요 : " + prevPage);
			session.setAttribute("prevPage", prevPage);			
		}
//		System.out.println("memberLogin");
		return "login/login";
	}
	
	@GetMapping("Mypage") //메인화면에서 버튼 클릭시 mypage이동
	public String mypage(Model model,HttpSession session) {
		String sId = (String)session.getAttribute("sId");
		// 마이페이지 최근 예매 내역 
		List<Map<String, String>> resMap = reserve.getMypage(sId);
		// 마이페이지 최근 상품 구매 내역
		List<RefundVO> productList = service.getMypageProductList(sId);
		
		model.addAttribute("productList", productList);
		model.addAttribute("resMap",resMap);
		
		
		return "login/Mypage";
	}
	
	@PostMapping("MemberLoginPro") // 로그인 클릭 시 메인페이지로 이동
	public String memberLoginPro(MemberVO member,String rememberId, HttpSession session, HttpServletResponse response,  Model model) {
		// 세션에 저장된 로그인창 이전 페이지를 변수로 저장
		String prevPage = (String)session.getAttribute("prevPage");
		System.out.println("이전 이전 페이지는 어디인가요????? : " + prevPage);
		
		
	    MemberVO dbMember = service.getMember(member);
	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    
	    if(dbMember == null || !member.getMember_id().equals(dbMember.getMember_id())){ //로그인 아이디판별
	    	System.out.println("확인" + dbMember);
	    	model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지않습니다");
	    	return "fail_back";
	    }
	    
	    
	    
	   if(dbMember.getMember_status() == 2) { //탈퇴한 회원은 로그인 불가
		   model.addAttribute("msg", "이미 탈퇴한 회원입니다");
		   return "fail_back";
	   }
	    
	    
	    if(dbMember == null || !passwordEncoder.matches(member.getMember_passwd(), dbMember.getMember_passwd())) {//로그인 실패시
	    	model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지않습니다");
	    	return "fail_back";
	    	
	    } else { // 로그인 성공시
	    	Cookie cookie = new Cookie("cookieId", dbMember.getMember_id()); // 쿠키에 아이디 저장
	    	if(rememberId == null) { // 아이디 저장을 체크했을 경우
	    		cookie.setMaxAge(0); // 쿠키의 유효기간을 0으로 체크
	    	} else {
	    		cookie.setMaxAge(60 * 60 * 24); // 쿠키의 유효기간을 1일로 설정
	    	}
	    	response.addCookie(cookie);
	    	model.addAttribute("dbMember", dbMember);
	    	session.setAttribute("sId", member.getMember_id());
	    	System.out.println("로그인 성공: " + dbMember);
	    		//주소값 뒤에 파라미터값을 판별해서 각 페이지로 이동한다.
	    		if(prevPage == null || prevPage.equals("") || prevPage.equals("idFind") 
	    				|| prevPage.equals("modifyMemberPw") || prevPage.equals("memberJoinPro")) { // 이전 페이지가 메인페이지거나 돌아가면 안되는 페이지인 경우
	    			return "redirect:/";
	    		} else {
	    			// 메인페이지가 아닐 경우 해당 페이지로 리다이렉트한다.
	    			return "redirect:/" + prevPage;
	    		}
	    }
	}
	
	@GetMapping("MemberLogout") //로그아웃
	public String logout(HttpSession session) {
		session.invalidate(); //세션값 초기화
		
		return "redirect:/";
	}
	
	
	@GetMapping("SideEditmember") //회원수정 페이지 이동
	public String sideEditmember(MemberVO member, HttpSession session, Model model) {
		// 세션 아이디가 없을 경우 "fail_back" 페이지를 통해 "잘못된 접근입니다" 출력 처리
	    String sId = (String) session.getAttribute("sId");
	    if (sId == null) {
	        model.addAttribute("msg", "로그인이 필요합니다");
	        model.addAttribute("targetURL", "memberLogin");
	        return "forward";
	    } 
		//(memberid가 null 또는 널스트링이고 세션Id가 admin이거나),sId가 admin이 아닐때
		//id를 세션아이디로 바꾸기
		if(!sId.equals("admin") || (sId.equals("admin") && (member.getMember_id() == null || member.getMember_id().equals("")))) {
			member.setMember_id(sId);
		}
		MemberVO dbMember = service.getMember(member);
		
		model.addAttribute("member",dbMember);
		return "login/editmember";
	}
	
	@GetMapping("Editmember") // 회원수정 페이지 이동
	public String Editmember(MemberVO member, HttpSession session, Model model, String newPasswd, String oldPasswd) {
	    // 세션 아이디가 없을 경우 "fail_back" 페이지를 통해 "잘못된 접근입니다" 출력 처리
	    String sId = (String) session.getAttribute("sId");
	    if (sId == null) {
	        model.addAttribute("msg", "잘못된 접근입니다");
	        return "fail_back";
	    }
	    
	    // (memberid가 null 또는 널스트링이고 세션Id가 admin이거나),sId가 admin이 아닐때
	    // id를 세션아이디로 변경하기
	    if (!sId.equals("admin") || (sId.equals("admin") && (member.getMember_id() == null || member.getMember_id().equals("")))) {
	        member.setMember_id(sId);
	    }
	    member.setMember_id(sId);

	    // 기존에 있던 회원 비밀번호 조회
	    MemberVO dbmember = service.selectMemberPs(member);
	    // 기존 비밀번호 저장
	    // oldPasswd와 기존 패스워드 비교하여 일치할 경우에만 정보 수정 또는 회원 탈퇴 기능 실행
	    // 새 비밀번호가 있을 경우 암호화 처리
	    
//	    BCryptPasswordEncoder passwoedEncoder = new BCryptPasswordEncoder();
//	    if (newPasswd != null && !newPasswd.equals("")) {
//	        newPasswd = passwoedEncoder.encode(newPasswd);
//	    }
	    
	    // 기존 비밀번호 확인하기
	    member.setMember_id(sId);
	    member.setMember_passwd(dbmember.getMember_passwd());
	    
	    
	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    
//	    BCryptPasswordEncoder passwordEncoder2 = new BCryptPasswordEncoder();
	    
	    if (oldPasswd == null || oldPasswd.equals("")) {
	        model.addAttribute("msg", "기존 비밀번호를 입력하세요.");
	        return "fail_back";
	    }

	    if (newPasswd == null || newPasswd.equals("")) {
	        model.addAttribute("msg", "새 비밀번호를 입력하세요.");
	        return "fail_back";
	    }
	    
	 // 기존 비밀번호와 DB에 저장된 비밀번호가 다를 경우 실패 처리
	    if (!passwordEncoder.matches(oldPasswd, dbmember.getMember_passwd())) {
	        model.addAttribute("msg", "기존 비밀번호가 올바르지 않습니다.");
	        return "fail_back";
	    }

	    // 새로운 비밀번호와 기존 비밀번호가 동일할 경우 실패 처리
	    if (oldPasswd.equals(newPasswd)) {
	        model.addAttribute("msg", "기존 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.");
	        return "fail_back";
	    }
	    
	    if (oldPasswd != null && passwordEncoder.matches(oldPasswd, dbmember.getMember_passwd())) {
	    BCryptPasswordEncoder passwoedEncoder = new BCryptPasswordEncoder();
	    if (newPasswd != null && !newPasswd.equals("")) {
	    	newPasswd = passwoedEncoder.encode(newPasswd);
	    }
	    	
            int checkMember = service.checkMember(sId, newPasswd);
            
	            if (checkMember > 0) {
	                model.addAttribute("msg", "수정이 완료되었습니다.");
	                model.addAttribute("targetURL", "Mypage");
	                return "forward";
	            } else {
	                model.addAttribute("msg", "수정에 실패했습니다.");
	                return "fail_back";
	            }
	            } else {
	        model.addAttribute("msg", "기존 비밀번호가 틀렸습니다.");
	        return "fail_back";
	    }
	}
		
	// 회원 탈퇴를 위한 회원조회
	@GetMapping("memberDie")
	public String memberDie(HttpSession session ,Model model, MemberVO member, String oldPasswd) {
		String sId = (String) session.getAttribute("sId");
		if (sId == null) {
			model.addAttribute("msg", "잘못된 접근입니다");
			return "fail_back";
		}
		member.setMember_id(sId);
		
		if(sId.contains("@")) { // 네이버 이메일 아이디의 경우
			System.out.println("네이버 이메일 아이디");
			String access_token = (String) session.getAttribute("access_token");
			System.out.println(access_token);
			
			NaverLoginVO naverLoginVO = new com.itwillbs.c5d2308t1.vo.NaverLoginVO();
			String apiUrl = "https://nid.naver.com/oauth2.0/token?grant_type=delete&client_id="+ naverLoginVO.CLIENT_ID +
					"&client_secret="+naverLoginVO.CLIENT_SECRET+"&access_token="+access_token+"&service_provider=NAVER";
			
			int dbmember = service.statusMember(member); 
			
			if (dbmember > 0) {
				model.addAttribute("msg", "회원탈퇴가 완료되었습니다.");
				model.addAttribute("targetURL", "./");
				session.invalidate();
				return "forward";
			} else {
				model.addAttribute("msg", "회원탈퇴에 실패했습니다.");
				model.addAttribute("targetURL", "SideEditmember");
				return "forward";
			}		
			
		} else { // 일반 회원일 경우
			System.out.println("현재 내아이디 : " + member.getMember_id());
			// 기존에 있던 회원 비밀번호 조회
			MemberVO dbmemberPs = service.selectMemberPs(member);
			// 기존 비밀번호 저장
			member.setMember_passwd(dbmemberPs.getMember_passwd());
			
			// 입력받는 비밀번호
			System.out.println("현재 나의 비밀번호 :" + member.getMember_passwd());
			System.out.println("내가 입력받은 비밀번호 :" +  oldPasswd);
			BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
			if (oldPasswd != null && passwordEncoder.matches(oldPasswd, dbmemberPs.getMember_passwd())) {
				int dbmember = service.statusMember(member); 
				if (dbmember > 0) {
					model.addAttribute("msg", "회원탈퇴가 완료되었습니다.");
					model.addAttribute("targetURL", "./");
					session.invalidate();
					return "forward";
				} else {
					model.addAttribute("msg", "회원탈퇴에 실패했습니다.");
					model.addAttribute("targetURL", "SideEditmember");
					return "forward";
				}
			} else {
				if (oldPasswd == null || oldPasswd.equals("")) {
					model.addAttribute("msg", "기존 비밀번호를 입력하세요.");
				} else {
					model.addAttribute("msg", "비밀번호가 틀렸습니다.");
				}
				model.addAttribute("targetURL", "SideEditmember");
				return "forward";
			}
			
		
		}
	}
		
	@GetMapping("MypageReviewList")//리뷰 페이지로 이동
	public String Mypage_ReviewList(@RequestParam(defaultValue = "1") int pageNum ,HttpSession session, Model model, ReviewsVO review) {
		String sId = (String)session.getAttribute("sId");
		review.setMember_id(sId); //현재 세션에 저장된 Id를 가져와서 review 객체의 member_id에 설정
		if (sId == null) {
			model.addAttribute("msg", "로그인이 필요합니다");
			model.addAttribute("targetURL","memberLogin");
			return "forward";
		}		
		
		
		List<ReviewsVO> myReview = service.getReviewList(review);
		
		int listCount = service.getReviewCount(sId);
		
		PageDTO page = new PageDTO(pageNum, 5);
		
		PageCount pageInfo = new PageCount(page, listCount, 3);
		
		List<HashMap<String, Object>> myReviewList = service.selectMyReviewList(sId, page);
		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		for(HashMap<String, Object> map : myReviewList) {
			// map으로 받아온 cs_date는 datetime 컬럼이기에 LocalDateTime 타입으로 가져온다.
			LocalDateTime date = (LocalDateTime)map.get("review_date");
			map.put("review_date", date.format(dtf));
		}
		model.addAttribute("myOneOnOneList", myReviewList);
		model.addAttribute("sId", sId);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("myReviewList", myReviewList);
		
		
		model.addAttribute("reviewBoard", myReview);
		return "login/Mypage_ReviewList";		
	}
	
	
	@GetMapping("reviewDetail")//리뷰 상세 페이지로 이동
	public String reviewDetail(HttpSession session, Model model, ReviewsVO review) {
		String sId = (String)session.getAttribute("sId");//현재 로그인 중인 아이디 sId 저장
		review.setMember_id(sId);
		
		if(sId == null) { // sId가 null일때 로그인창으로 보내기
			model.addAttribute("msg","로그인이 필요합니다");
			model.addAttribute("targetURL","memberLogin");
			return "forward";
		}
		
		List<ReviewsVO> myReviewDetail = service.getReviewDetailList(review); //리뷰 상세조회
		
		model.addAttribute("myReviewDetail",myReviewDetail);
		
		return "login/Mypage_ReviewDetail";
		
	}
	
	@GetMapping("reviewDelete") //리뷰 삭제
	public String reviewDelete(HttpSession session, Model model, ReviewsVO review) {
		String sId = (String)session.getAttribute("sId");//현재 로그인 중인 아이디 sId 저장
		review.setMember_id(sId);
		if(sId == null) { // sId가 null일때 로그인창으로 보내기
			model.addAttribute("msg","로그인이 필요합니다");
			model.addAttribute("targetURL","memberLogin");
			return "forward";
		}
		
		int deleteCount = service.deleteReview(review);
		
		if(deleteCount > 0) {
			//삭제 성공
			return "redirect:/MypageReviewList";
		}else {
			//삭제 실패
			model.addAttribute("msg","리뷰글 삭제 실패");
			return "fail_back";
		}
		
	}
	
	
	// ============================================================================	
	// =====================마이페이지 나의게시글 1대1문의 내역==================
	// 마이페이지 나의 게시글 1대1문의 내역 조회 게시판으로 이동
	@GetMapping("MypageOneOnOneList")
	public String mypage_OneOnOneList(@RequestParam(defaultValue = "1") int pageNum, HttpSession session, Model model, MemberVO member) {
		String sId = (String)session.getAttribute("sId");
		member.setMember_id(sId);
		if(sId == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			model.addAttribute("targetURL", "memberLogin");
			return "forward";
		}
		// 페이지 번호와 글의 개수를 파라미터로 전달
		PageDTO page = new PageDTO(pageNum, 5);
		
		// LoginService - getMyOneOnOnePostsCount() 메서드 호출해 전체 게시글 개수 조회
		// => 파라미터 : 세션 아이디(sId)	 리턴타입 : int
		int listCount = service.getMyOneOnOnePostsCount(sId);
		
		// PageDTO 객체와 게시글 갯수, 페이지 번호 갯수를 파라미터로 전달
		PageCount pageInfo = new PageCount(page, listCount, 3);
		
		// LoginService - getMyOneOnOnePosts() 메서드 호출해 글 목록 조회
		// => 파라미터 : 세션 아이디(sId), PageDTO 객체(page) 	 리턴 타입 : List<HashMap<String, Object>>(myOneOnOneList)
		List<HashMap<String, Object>> myOneOnOneList = service.getMyOneOnOnePosts(sId, page);
//		List<HashMap<String, Object>> myOneOnOneList = service.getMyOneOnOnePosts(sId);
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		for(HashMap<String, Object> map : myOneOnOneList) {
			// map으로 받아온 cs_date는 datetime 컬럼이기에 LocalDateTime 타입으로 가져온다.
			LocalDateTime date = (LocalDateTime)map.get("cs_date");
			map.put("cs_date", date.format(dtf));
		}
//		System.out.println("myOneOnOneList : " + myOneOnOneList);
		model.addAttribute("myOneOnOneList", myOneOnOneList);
		model.addAttribute("sId", sId);
		model.addAttribute("pageInfo", pageInfo);
		
		return "login/Mypage_OneOnOneList";
	}

	
	// 마이페이지 나의 게시글 1대1문의 상세 조회
	@GetMapping("MypageOneOnOneDetail")
	public String MypageOneOnOneDetail(HttpSession session, Model model, CsVO cs) {
		String sId = (String)session.getAttribute("sId");
		if(sId == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			model.addAttribute("targetURL", "memberLogin");
			return "forward";
		}
		
		// LoginService - getMyOneOnOneDetail() 메서드 호출해 해당 글 상세 내용 조회
		// 파라미터 : CsVO 객체(cs) 		리턴타입 : Map<String, Object> (oneOnOne) 
		Map<String, Object> oneOnOne = service.getMyOneOnOneDetail(cs);
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		// map으로 받아온 cs_date는 datetime 컬럼이기에 LocalDateTime 타입으로 가져온다.
		LocalDateTime date = (LocalDateTime)oneOnOne.get("cs_date");
		oneOnOne.put("cs_date", date.format(dtf));
		
		model.addAttribute("oneOnOne", oneOnOne);

		return "login/Mypage_OneOnOne";
	}
	
	// 마이페이지 나의 게시글 1대1문의 글 삭제
	@GetMapping("MyPageOneOnOneDelete")
	public String MyPageOneOnOneDelete(HttpSession session, Model model, CsVO cs) {
		String sId = (String)session.getAttribute("sId");
		if(sId == null) {
			model.addAttribute("msg", "로그인이 필요합니다!");
			model.addAttribute("targetURL", "memberLogin");
			return "forward";
		}
		
		// 해당 게시물 정보 조회
		Map<String, Object> oneOnOne = service.getMyOneOnOneDetail(cs);
		
		if(!sId.equals(oneOnOne.get("member_id"))) {
			model.addAttribute("msg", "삭제권한이 없습니다!");
			return "fail_back";
		}
		
		cs.setMember_id(oneOnOne.get("member_id").toString());

		// LoginService - removeMyOneOnOne() 메서드 호출해 해당 글 상세 내용 조회
		// 파라미터 : CsVO 객체(cs) 		리턴타입 : int (deleteCount) 
		int deleteCount = service.removeMyOneOnOne(cs);
		if(deleteCount > 0) {
			// 서버에서 파일 삭제 작업
			try {
				String uploadDir = "/resources/upload";
				String saveDir = session.getServletContext().getRealPath(uploadDir);
				String fileName = oneOnOne.get("cs_file").toString();
				
				if(!fileName.equals("")) {
					Path path = Paths.get(saveDir + "/" + fileName);
					Files.deleteIfExists(path);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			return "redirect:/MypageOneOnOneList";
		} else {
			model.addAttribute("msg", "1대1문의 글 삭제에 실패했습니다!");
			return "fail_back";
		}
	}
	
	// ============================================================================	
	
	
	
	// 분실물 문의 게시판으로 이동
	@GetMapping("MypageLostBoardList")
	public String LostBoard(@RequestParam(defaultValue = "1") int pageNum,Model model, HttpSession session, CsVO myCs) { 
		
		String sId = (String)session.getAttribute("sId");
		if (sId == null) {
			model.addAttribute("msg", "로그인이 필요합니다");
			model.addAttribute("targetURL","memberLogin");
			return "forward";
		}		
		myCs.setMember_id(sId);
		
//		List<CsVO> myLost = service.getLostBoardList(myCs);
		
		PageDTO page = new PageDTO(pageNum, 5);
		
		int listCount = service.getLostBoardCount(sId);
		// 페이지 번호와 글의 개수를 파라미터로 전달
		
		PageCount pageInfo = new PageCount(page, listCount, 3);
		
		List<HashMap<String, Object>> myLostBoardList = service.selectLostListCount(sId, page);
		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		for(HashMap<String, Object> map : myLostBoardList) {
			// map으로 받아온 cs_date는 datetime 컬럼이기에 LocalDateTime 타입으로 가져온다.
			LocalDateTime date = (LocalDateTime)map.get("cs_date");
			map.put("cs_date", date.format(dtf));
		}
		model.addAttribute("myOneOnOneList", myLostBoardList);
		model.addAttribute("sId", sId);
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("myLostBoardList", myLostBoardList);
		
		
		return "login/Mypage_LostBoard_List";
	}
	// 마이페이지 분실물 삭제
	@GetMapping("myLostDelete")
	public String myLostDelete(HttpSession session, Model model, CsVO cs) {
		String sId = (String)session.getAttribute("sId");
		if(sId == null) {
			model.addAttribute("msg", "로그인이 필요합니다!");
			model.addAttribute("targetURL", "memberLogin");
			return "forward";
		}
		
		// 해당 게시물 정보 조회
		Map<String, Object> myLost = service.getMyLostDetail(cs);
		
		if(!sId.equals(myLost.get("member_id"))) {
			model.addAttribute("msg", "삭제권한이 없습니다!");
			return "fail_back";
		}
		
		cs.setMember_id(myLost.get("member_id").toString());

		// LoginService - removeMyOneOnOne() 메서드 호출해 해당 글 상세 내용 조회
		// 파라미터 : CsVO 객체(cs) 		리턴타입 : int (deleteCount) 
		int deleteCount = service.removeMyLost(cs);
		if(deleteCount > 0) {
			// 서버에서 파일 삭제 작업
			try {
				String uploadDir = "/resources/upload";
				String saveDir = session.getServletContext().getRealPath(uploadDir);
				String fileName = myLost.get("cs_file").toString();
				
				if(!fileName.equals("")) {
					Path path = Paths.get(saveDir + "/" + fileName);
					Files.deleteIfExists(path);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			return "redirect:/MypageLostBoardList";
		} else {
			model.addAttribute("msg", "1대1문의 글 삭제에 실패했습니다!");
			return "fail_back";
		}
	}
	
	
	// ======================= 마이페이지 상품 구매 내역===============================================
	// 마이페이지 상품 구매 내역
	@GetMapping("MypageProductboardList")
	public String mypage_Product_boardList(HttpSession session,RefundVO refund, Model model
			, @RequestParam(defaultValue = "1")  int pageNum) { // 상품내역 게시판
		// 세션 아이디 저장
		String sId = (String)session.getAttribute("sId");
		if(sId == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			model.addAttribute("targetURL", "memberLogin");
			return "forward";
		}
		// 세션 아이디 refund.member_id에 저장
		refund.setMember_id(sId);
		// 페이지 번호와 글의 개수를 파라미터로 전달
		PageDTO page = new PageDTO(pageNum, 5);
		int listCount = service.getStoreListCount(sId);
		PageCount pageInfo = new PageCount(page, listCount, 3);

		List<RefundVO> myStoreList = service.getMyStoreList(sId, page);
		model.addAttribute("myStoreList", myStoreList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "login/Mypage_product_boardList";
	}
	
	// 마이페이지 구매내역 상세 페이지
	@GetMapping("MypageProductListDtail")
	public String mypage_Product_boardListX(HttpSession session, RefundVO refund, Model model
			,@RequestParam(defaultValue = "1") int pageNum) { // 상품내역 게시판
		String sId = (String)session.getAttribute("sId");
		if(sId == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			model.addAttribute("targetURL", "memberLogin");
			return "forward";
		}
		
		refund = service.getMyStoreDetail(refund); 
		
		model.addAttribute("refund", refund);
		
		
		return "login/Mypage_product_detail";
	}
	
	// 마이페이지 상세 페이지 구매 취소
	@ResponseBody
	@PostMapping("MypageBuyCancel")
	public boolean mypageProductDetailDel(@RequestParam Map<String, String> map) { // 상품내역 게시판
		int updateCount = service.getMyStoreBuyCancel(map);
		
		if(updateCount > 0) {
			return true;
		} else {
			return false;
		}
	}
	// ======================================================================
	
	//마이페이지 예매 취소 상세내역 팝업창
	@GetMapping("refundInfoDetailPro")
	public String resInfoDetailPro(@RequestParam String payment_id, Map<String, String> map, Model model) {
		map = reserve.getresInfoDetail(payment_id);
		model.addAttribute("map",map);
		return"login/popup3";
	}
	
	// 마이페이지 분실물 상세 조회
		@GetMapping("MypageLostBoardDetail")
		public String LostBoardDetail(HttpSession session,Model model, CsVO cs) {
			
			// cs_id가 저장된 cs 객체 전달하여 게시글 가져오기(극장명이 포함되어 HashMap 객체로 저장)
			Map<String, Object> myLostDetail = service.getlostnfound(cs);
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			// map으로 받아온 cs_date는 datetime 컬럼이기에 LocalDateTime 타입으로 가져온다.
			LocalDateTime date = (LocalDateTime)myLostDetail.get("cs_date");
			myLostDetail.put("cs_date", date.format(dtf));
			model.addAttribute("myLostDetail", myLostDetail);
			
		return "login/Mypage_LostBoardDetail";
	}
		
	// 아이디 찾기
	@GetMapping("idFind")
	public String idFind(HttpSession session, Model model) {
		String sId = (String)session.getAttribute("sId");
		if(sId != null) { // 로그인한 경우
			model.addAttribute("msg", "이미 로그인된 계정입니다");
			model.addAttribute("targetURL", "./");
			return "forward";
		}
		return "login/id_find";
	}
		
	// 아이디 찾기 비즈니스 로직 수행
	@ResponseBody
	@GetMapping("idFindPro")
	public MemberVO idFindPro(MemberVO member, Model model) {
		// 이름과 이메일이 일치하는 회원 검색
		MemberVO dbMember = service.findMember(member);
		return dbMember;
	}
	
	// 비밀번호 찾기
	@GetMapping("pwFind")
	public String passwdFind(HttpSession session, Model model) {
		String sId = (String)session.getAttribute("sId");
		if(sId != null) { // 로그인한 경우
			model.addAttribute("msg", "이미 로그인된 계정입니다");
			model.addAttribute("targetURL", "./");
			return "forward";
		}
		return "login/pw_find";
	}
	
	// 비밀번호 찾기 비즈니스 로직 수행
	@ResponseBody
	@GetMapping("memberCheck")
	public boolean memberCheck(MemberVO member) {
		MemberVO dbMember = service.getMember(member);
		
		// 없는 아이디거나 회원의 이름을 잘못입력한 경우
		if(dbMember == null || !dbMember.getMember_name().equals(member.getMember_name())) {
			return false;
		} else { // 입력한 정보와 일치하는 경우
			return true;			
		}
		
	}
	
	// 비밀번호 수정 페이지로 이동
	@PostMapping("modifyMemberPw")
	public String findMemberInfo(MemberVO member, HttpSession session, Model model) {
		String sId = (String)session.getAttribute("sId");
		if(sId != null) { // 로그인한 경우
			model.addAttribute("msg", "잘못된 접근입니다!");
			model.addAttribute("targetURL", "./");
			return "forward";
		}
		model.addAttribute("member", member);
		return "login/pw_modify";
	}
		
	// 비밀번호 수정 비즈니스 로직 수행
	@ResponseBody
	@PostMapping("modifyMemberPwPro")
	public boolean modifyMemberPwPro(MemberVO member, String newPasswd) {
		System.out.println("새로운 비밀번호 : " + newPasswd);
		
		// 새로운 비밀번호의 암호화 처리
		BCryptPasswordEncoder passwoedEncoder = new BCryptPasswordEncoder();
		if(newPasswd != null && !newPasswd.equals("")) {
			newPasswd = passwoedEncoder.encode(newPasswd);
		}
		// 회원 아이디와 새로운 비밀번호로 수정 작업 요청
		int updateCount = service.modifyMemberPw(member, newPasswd);
		
		if(updateCount > 0) {
			return true;
		} else {
			return false;
		}
	}
}
