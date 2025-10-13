(function () {
    const I18N = {
        // Ngôn ngữ hiện tại
        lang:
                localStorage.getItem("lang") ||
                (navigator.language &&
                        navigator.language.toLowerCase().startsWith("vi")
                        ? "vi"
                        : "en"),

        // ================= DICTIONARY =================
        dict: {
            common: {
                choose_language: {vi: "Chọn ngôn ngữ và khu vực", en: "Choose language & region"},
                translation_autoswitch_help: {
                    vi: "Dịch tự động nội dung mô tả và đánh giá sang Tiếng Việt.",
                    en: "Automatically translate descriptions and reviews into Vietnamese."
                },
                close: {vi: "Đóng", en: "Close"}
            },

            // ===== HEADER =====
            header: {
                logo: {"aria-label": {vi: "Trang chủ", en: "Home"}},
                nav: {
                    home: {vi: "Trang chủ", en: "Home"},
                    stay: {vi: "Nơi lưu trú", en: "Stays"},
                    experience: {vi: "Trải nghiệm", en: "Experiences"},
                    service: {vi: "Dịch vụ", en: "Services"}
                },
                host: {
                    hosting_btn: {vi: "Đón tiếp khách", en: "Hosting"},
                    become_host: {vi: "Trở thành host", en: "Become a Host"}
                },
                profile: {
                    "aria-label": {vi: "Hồ sơ", en: "Profile"},
                    user_profile: {"aria-label": {vi: "Hồ sơ người dùng", en: "User profile"}},
                    main_nav: {"aria-label": {vi: "Menu điều hướng chính", en: "Main navigation menu"}}
                },
                dropdown: {
                    wishlist: {vi: "Danh sách yêu thích", en: "Wishlist"},
                    trips: {vi: "Chuyến đi", en: "Trips"},
                    messages: {vi: "Tin nhắn", en: "Messages"},
                    profile: {vi: "Hồ sơ", en: "Profile"},
                    notifications: {vi: "Thông báo", en: "Notifications"},
                    settings: {vi: "Cài đặt tài khoản", en: "Account settings"},
                    language_currency: {vi: "Ngôn ngữ và loại tiền tệ", en: "Language & currency"},
                    help_center: {vi: "Trung tâm trợ giúp", en: "Help Center"},
                    logout: {vi: "Đăng xuất", en: "Log out"}
                },
                search: {
                    location_label: {vi: "Địa điểm", en: "Location"},
                    location: {placeholder: {vi: "Tìm kiếm điểm đến", en: "Search destination"}},
                    checkin_label: {vi: "Nhận phòng", en: "Check in"},
                    checkout_label: {vi: "Trả phòng", en: "Check out"},
                    guests_label: {vi: "Khách", en: "Guests"},
                    guests: {placeholder: {vi: "Thêm khách", en: "Add guests"}},
                    button: {"aria-label": {vi: "Tìm kiếm", en: "Search"}}
                }
            },

            // ===== HOME =====
            home: {
                title: {vi: "Trang chủ", en: "Home"},
                featured: {
                    title: {vi: "Các nơi lưu trú nổi bật", en: "Featured Stays"},
                    empty: {vi: "Không tìm thấy kết quả nào.", en: "No results found."}
                },
                search: {
                    location_label: {vi: "Địa điểm", en: "Location"},
                    location: {placeholder: {vi: "Tìm kiếm điểm đến", en: "Search destination"}},
                    checkin_label: {vi: "Nhận phòng", en: "Check in"},
                    checkout_label: {vi: "Trả phòng", en: "Check out"},
                    guests_label: {vi: "Khách", en: "Guests"},
                    guests: {placeholder: {vi: "Thêm khách", en: "Add guests"}},
                    button: {"aria-label": {vi: "Tìm kiếm", en: "Search"}}
                }
            },

            // ===== LOGIN =====
            login: {
                title: {vi: "Đăng nhập", en: "Sign in"},
                email: {placeholder: {vi: "Email", en: "Email"}},
                password: {placeholder: {vi: "Mật khẩu", en: "Password"}},
                forgot: {vi: "Quên mật khẩu?", en: "Forgot password?"},
                google: {vi: "Đăng nhập bằng Google", en: "Sign in with Google"},
                no_account: {vi: "Chưa có tài khoản?", en: "Don't have an account?"},
                signup_now: {vi: "Đăng ký ngay", en: "Sign up now"}
            },

            // ===== REGISTER =====
            register: {
                title: {vi: "Đăng ký", en: "Sign up"},
                email: {placeholder: {vi: "Email", en: "Email"}},
                password: {placeholder: {vi: "Mật khẩu", en: "Password"}},
                repassword: {placeholder: {vi: "Nhập lại mật khẩu", en: "Confirm password"}},
                submit: {vi: "Tạo tài khoản", en: "Create account"}
            },

            // ===== HOST (DÀNH CHO NGƯỜI CHO THUÊ NHÀ) =====
            host: {
                listings: {
                    title: {vi: "Bài đăng của bạn", en: "Your listings"},
                    empty: {vi: "Bạn chưa có bài đăng nào.", en: "You have no listings yet."},
                    add_btn: {vi: "+ Thêm chỗ ở", en: "+ Add a stay"},
                    switch_travel_mode: {vi: "Chuyển sang chế độ du lịch", en: "Switch to travel mode"},
                    today: {vi: "Hôm nay", en: "Today"},
                    calendar: {vi: "Lịch", en: "Calendar"},
                    messages: {vi: "Tin nhắn", en: "Messages"},
                    listing_view: {vi: "Chế độ xem danh sách", en: "List view"},
                    grid_view: {vi: "Chế độ xem lưới", en: "Grid view"}
                }
            },

            // ===== FOOTER =====
            footer: {
                support: {
                    title: {vi: "Hỗ trợ", en: "Support"},
                    support_center: {vi: "Trung tâm trợ giúp", en: "Help Center"},
                    contact: {vi: "Liên hệ", en: "Contact"},
                    transaction_protection: {vi: "Bảo vệ giao dịch", en: "Transaction protection"},
                    anti_discrimination: {vi: "Chống phân biệt đối xử", en: "Anti-discrimination"},
                    accessibility: {vi: "Hỗ trợ người khuyết tật", en: "Accessibility support"},
                    cancellation_options: {vi: "Các tùy chọn hủy", en: "Cancellation options"},
                    neighborhood_concerns: {vi: "Báo cáo lo ngại của khu dân cư", en: "Neighborhood concerns"}
                },
                hosting: {
                    title: {vi: "Đón tiếp khách", en: "Hosting"},
                    host_onboarding: {vi: "Cho thuê nhà trên GO2BNB", en: "Become a host on GO2BNB"},
                    experience_upload: {vi: "Đưa trải nghiệm của bạn lên GO2BNB", en: "Publish your experience on GO2BNB"},
                    service_upload: {vi: "Đưa dịch vụ của bạn lên GO2BNB", en: "Publish your service on GO2BNB"},
                    aircover: {vi: "AirCover cho host", en: "AirCover for Hosts"},
                    hosting_resources: {vi: "Tài nguyên về đón tiếp khách", en: "Hosting resources"},
                    community_forum: {vi: "Diễn đàn cộng đồng", en: "Community forum"},
                    responsible_hosting: {vi: "Đón tiếp khách có trách nhiệm", en: "Responsible hosting"},
                    hosting_course: {vi: "Tham gia khóa học miễn phí về công việc đón tiếp khách", en: "Take the free course on hosting"},
                    host_support: {vi: "Tìm host hỗ trợ", en: "Find host support"}
                },
                company: {
                    title: {vi: "GO2BNB", en: "GO2BNB"},
                    release: {vi: "Bản phát hành Mùa hè 2025", en: "Summer 2025 Release"},
                    news: {vi: "Trang tin tức", en: "Newsroom"},
                    careers: {vi: "Cơ hội nghề nghiệp", en: "Careers"},
                    investors: {vi: "Nhà đầu tư", en: "Investors"},
                    org_support: {vi: "Chỗ ở khẩn cấp GO2BNB.org", en: "GO2BNB.org emergency stays"}
                },
                bottom: {
                    privacy: {vi: "Quyền riêng tư", en: "Privacy"},
                    terms: {vi: "Điều khoản", en: "Terms"},
                    sitemap: {vi: "Sơ đồ trang web", en: "Sitemap"},
                    language: {"aria-label": {vi: "Ngôn ngữ", en: "Language"}},
                    currency: {"aria-label": {vi: "Tiền tệ", en: "Currency"}},
                    facebook: {"aria-label": {vi: "Facebook", en: "Facebook"}},
                    tiktok: {"aria-label": {vi: "Tiktok", en: "Tiktok"}},
                    youtube: {"aria-label": {vi: "Youtube", en: "YouTube"}}
                }
            }
        },

        // ================= CORE =================
        setLang(l) {
            I18N.lang = l;
            localStorage.setItem("lang", l);
            I18N.apply();
            document.documentElement.setAttribute("lang", l);
            I18N.updateBadge();
        },

        // lấy text theo key
        t(key) {
            const parts = key.split(".");
            let node = I18N.dict;
            for (const p of parts) {
                if (!node)
                    break;
                node = node[p];
            }
            if (node && (I18N.lang in node))
                return node[I18N.lang];
            if (node && typeof node === "object")
                return node["en"] || node["vi"] || key;
            return key;
        },

        // cập nhật chỉ phần chữ của badge (không xoá icon)
        updateBadge() {
            const badge = document.getElementById("lang-badge");
            if (!badge)
                return;
            const label = badge.querySelector("[data-lang-label]");
            const text = I18N.lang === "vi" ? "Tiếng Việt (VN)" : "English (EN)";
            if (label)
                label.textContent = text;
        },

        // áp text vào DOM
        apply(root) {
            const scope = root || document;

            scope.querySelectorAll("[data-i18n]").forEach((el) => {
                const key = el.getAttribute("data-i18n");
                const txt = I18N.t(key);
                if (el.tagName === "INPUT" || el.tagName === "TEXTAREA")
                    el.value = txt;
                else
                    el.textContent = txt;
            });

            scope.querySelectorAll("[data-i18n-attr]").forEach((el) => {
                const baseKey =
                        el.getAttribute("data-i18n") || el.getAttribute("data-i18n-base") || "";
                const attrs = (el.getAttribute("data-i18n-attr") || "")
                        .split(":")
                        .filter(Boolean);
                attrs.forEach((attr) => {
                    const key = (baseKey ? baseKey + "." : "") + attr;
                    el.setAttribute(attr, I18N.t(key));
                });
            });

            I18N.updateBadge();
        },

        // tạo modal nếu chưa có (ẩn mặc định bằng inline style)
        ensureModal() {
            if (document.getElementById("lang-modal"))
                return;

            const modal = document.createElement("div");
            modal.id = "lang-modal";
            modal.className = "lang-modal";
            modal.style.display = "none"; // ẩn mặc định

            modal.innerHTML = `
        <div class="lang-modal__backdrop" data-close="1"></div>
        <div class="lang-modal__panel" role="dialog" aria-modal="true" aria-labelledby="lang-modal-title">
          <button class="lang-modal__close" aria-label="${I18N.t("common.close")}" data-close="1">×</button>
          <div class="lang-modal__header">
            <div class="lang-modal__auto">
              <span class="lang-modal__auto-title">Bản dịch</span>
              <label class="lang-switch">
                <input type="checkbox" id="auto-vi"><span class="lang-switch__slider"></span>
              </label>
              <div class="lang-modal__auto-help" data-i18n="common.translation_autoswitch_help"></div>
            </div>
            <h2 id="lang-modal-title" class="lang-modal__title" data-i18n="common.choose_language"></h2>
          </div>
          <div class="lang-modal__grid">
            <button class="lang-option" data-lang="vi"><span class="lang-option__flag">🌐</span><span>Tiếng Việt (VN)</span></button>
            <button class="lang-option" data-lang="en"><span class="lang-option__flag">🌐</span><span>English (EN)</span></button>
          </div>
        </div>`;

            document.body.appendChild(modal);

            modal.addEventListener("click", (e) => {
                const t = e.target;
                if (t.dataset.close === "1")
                    I18N.hideModal();
                const btn = t.closest(".lang-option");
                if (btn) {
                    I18N.setLang(btn.dataset.lang);
                    I18N.hideModal();
                }
            });

            document.addEventListener("keydown", (e) => {
                if (e.key === "Escape")
                    I18N.hideModal();
            });

            I18N.apply(modal);
        },

        // mở/đóng modal + khóa cuộn
        showModal() {
            I18N.ensureModal();
            const el = document.getElementById("lang-modal");
            el.style.display = "block";
            document.documentElement.style.overflow = "hidden";
        },

        hideModal() {
            const el = document.getElementById("lang-modal");
            if (!el)
                return;
            el.style.display = "none";
            document.documentElement.style.overflow = "";
        },

        // init
        init() {
            I18N.ensureModal();
            I18N.apply();

            document
                    .querySelectorAll("[data-open-lang-modal]")
                    .forEach((el) =>
                        el.addEventListener("click", (e) => {
                            e.preventDefault();
                            I18N.showModal();
                        })
                    );
        }
    };

    window.I18N = I18N;
    document.addEventListener("DOMContentLoaded", I18N.init);
})();
