<%-- 
    Document   : header
    Created on : Sep 20, 2025, 8:57:56 PM
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <!--header-->
        <header>   
            <div class="header">
            <!--header top-->
            <div class="header-top">
                <!-- logo -->
                <a class="" aria-label="Trang chủ" href="home.jsp" style="">
                <img src="image/logo.jpg" alt="logo" width="100" style="display:block;">
                </a>

                <div class="menu" role="tablist">
                    <a href="/homes" class="menu-sub""
                        <span class="" style="transform: none;">
                            <img src="https://www.svgrepo.com/show/434116/house.svg" alt="Homestay Icon" width="40" height="40">
                        </span>
                        <span class="" data-title="Nơi lưu trú">
                            Nơi lưu trú
                        </span>
                    </a>
                    <a href="/experiences" class="menu-sub">
                        <span class="w14w6ssu atm_mk_h2mmj6 dir dir-ltr" style="transform: none;" aria-hidden="true">                
                            <img src="https://www.svgrepo.com/show/484353/balloon.svg" alt="Experience Icon" width="40" height="40">
                        </span>
                        <span class="" data-title="Trải nghiệm" aria-hidden="true">
                            Trải nghiệm
                        </span>
                    </a>
                    <a href="/services" class="menu-sub">
                        <span class="w14w6ssu atm_mk_h2mmj6 dir dir-ltr" style="transform: none;" aria-hidden="true">                          
                            <img src="https://www.svgrepo.com/show/206293/meal-lunch.svg" alt="Service Icon" width="40" height="40">                                       
                        </span>
                        <span class="" data-title="Dịch vụ" aria-hidden="true">
                            Dịch vụ
                        </span>
                    </a>
                </div>

                <nav aria-label="Hồ sơ" class="profile">                       
                    <button type="button" class="profile-host">
                        <span data-button-content="true" class="" style="font-size: 17px;">
                            Trở thành host
                        </span>
                    </button>
                    <div class="">
                        <button aria-label="Chọn ngôn ngữ và loại tiền tệ" type="button" class="profile-icon">
                            <span data-button-content="true" class="">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" aria-hidden="true" role="presentation" focusable="false" style="display: block; height: 16px; width: 16px; fill: currentcolor;">
                                <path d="M8 .25a7.77 7.77 0 0 1 7.75 7.78 7.75 7.75 0 0 1-7.52 7.72h-.25A7.75 7.75 0 0 1 .25 8.24v-.25A7.75 7.75 0 0 1 8 .25zm1.95 8.5h-3.9c.15 2.9 1.17 5.34 1.88 5.5H8c.68 0 1.72-2.37 1.93-5.23zm4.26 0h-2.76c-.09 1.96-.53 3.78-1.18 5.08A6.26 6.26 0 0 0 14.17 9zm-9.67 0H1.8a6.26 6.26 0 0 0 3.94 5.08 12.59 12.59 0 0 1-1.16-4.7l-.03-.38zm1.2-6.58-.12.05a6.26 6.26 0 0 0-3.83 5.03h2.75c.09-1.83.48-3.54 1.06-4.81zm2.25-.42c-.7 0-1.78 2.51-1.94 5.5h3.9c-.15-2.9-1.18-5.34-1.89-5.5h-.07zm2.28.43.03.05a12.95 12.95 0 0 1 1.15 5.02h2.75a6.28 6.28 0 0 0-3.93-5.07z">
                                </path>
                                </svg>
                            </span>
                        </button>
                    </div>
                    <div class="">
                        <button aria-label="Menu điều hướng chính" type="button" class="profile-icon">
                            <span data-button-content="true" class="">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" aria-hidden="true" role="presentation" focusable="false" style="display: block; fill: none; height: 16px; width: 16px; stroke: currentcolor; stroke-width: 3; overflow: visible;"><g fill="none">
                                <path d="M2 16h28M2 24h28M2 8h28">
                                </path>
                                </g>
                                </svg>
                            </span>
                        </button>
                    </div>
                 </nav>
                </div>
                <!--header bottom-->
                <div class="header-bottom">
                        <div class="">
                            <div class="each-search-filter" style="width: 220px;">
                                <div class="search-filter">
                                    Địa điểm
                                </div>
                                <div>
                                    <div class="search-filter-sub">
                                        Tìm kiếm điểm đến
                                    </div>                                                
                                </div>
                            </div>
                        </div>
                        <div class="" role="button" tabindex="0" aria-expanded="false" style="width: 120px;">
                            <div class="each-search-filter">
                                <div class="search-filter">
                                    Nhận phòng
                                </div>
                                <div>
                                    <div class="search-filter-sub">
                                        Thêm ngày
                                    </div>                                                       
                                </div>                                                   
                            </div>                                                
                        </div>
                        <div class="" role="button" tabindex="0" aria-expanded="false" style="width: 120px;">
                            <div class="each-search-filter">
                                <div class="search-filter">
                                    Trả phòng
                                </div>
                                <div>
                                    <div class="search-filter-sub">
                                        Thêm ngày
                                    </div>                                                       
                                </div>                                                
                            </div>                                               
                        </div>
                        <div class="" role="button" tabindex="0" aria-expanded="false" style="width: 220px;">
                            <div class="each-search-filter">
                                <div class="search-filter">
                                    Khách
                                </div>
                                <div>
                                    <div class="search-filter-sub">
                                        Thêm khách
                                    </div>                                                           
                                </div>                                                        
                            </div>   
                            <button class="" type="button" data-testid="structured-search-input-search-button" aria-label="Tìm kiếm">
                            <div class="" data-icon="true" data-testid="little-search-icon" style="border-radius: 50px; transform: none; transform-origin: 50% 50% 0px;">
                                <div style="transform: none; transform-origin: 50% 50% 0px;">
                                    <svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" role="presentation" focusable="false" style="display: block; fill: none; height: 16px; width: 16px; stroke: currentcolor; stroke-width: 4; overflow: visible;">
                                    <path d="m20.666 20.666 10 10">

                                    </path>
                                    <path d="m24.0002 12.6668c0 6.2593-5.0741 11.3334-11.3334 11.3334-6.2592 0-11.3333-5.0741-11.3333-11.3334 0-6.2592 5.0741-11.3333 11.3333-11.3333 6.2593 0 11.3334 5.0741 11.3334 11.3333z" fill="none">

                                    </path>
                                    </svg>
                                </div>
                            </div>
                         </button>
                        </div>                                                 
                </div>                                                
            </div>
        </header>
        
        <!--Trạng thái header thu nhỏ khi cuộn xuống-->
        <script>
            window.addEventListener("scroll", function() {
              const header = document.querySelector(".header");
              if (window.scrollY > 50) {   // cuộn xuống 50px
                header.classList.add("shrink");
              } else {
                header.classList.remove("shrink");
              }
            });
        </script>
</html>
