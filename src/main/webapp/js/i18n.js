(function () {
    const I18N = {
        // Ngôn ngữ hiện tại
        lang: localStorage.getItem("lang") || "vi",

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
                    become_host: {vi: "Trở thành host", en: "Become a Host"},
                    nav: {
                        today: {vi: "Hôm nay", en: "Today"},
                        calendar: {vi: "Lịch", en: "Calendar"},
                        listings: {vi: "Bài đăng", en: "Listings"},
                        inbox: {vi: "Tin nhắn", en: "Inbox"}
                    },
                    switch_to_guest: {vi: "Chuyển sang chế độ du lịch", en: "Switch to guest mode"}
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
                    language_currency: {vi: "Ngôn ngữ", en: "Language"},
                    language: {vi: "Ngôn ngữ", en: "Language"},
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
                page_title: {vi: "Trang chủ", en: "Home"},
                title: {vi: "Trang chủ", en: "Home"},
                featured: {
                    title: {vi: "Các nơi lưu trú nổi bật", en: "Featured Stays"},
                    empty: {vi: "Không tìm thấy kết quả nào.", en: "No results found."}
                },
                card: {
                    image: {
                        alt: {vi: "Hình ảnh chỗ ở", en: "Accommodation image"}
                    },
                    view_detail: {vi: "Xem chi tiết", en: "View details"},
                    per_night: {vi: "/đêm", en: "/night"}
                },
                search: {
                    location_label: {vi: "Địa điểm", en: "Location"},
                    location: {placeholder: {vi: "Tìm kiếm điểm đến", en: "Search destination"}},
                    checkin_label: {vi: "Nhận phòng", en: "Check in"},
                    checkout_label: {vi: "Trả phòng", en: "Check out"},
                    guests_label: {vi: "Khách", en: "Guests"},
                    guests: {placeholder: {vi: "Thêm khách", en: "Add guests"}},
                    button: {"aria-label": {vi: "Tìm kiếm", en: "Search"}},
                    results_for: {vi: "Kết quả tìm kiếm cho", en: "Search results for"}
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
                    grid_view: {vi: "Chế độ xem lưới", en: "Grid view"},
                    rental_item: {vi: "Mục cho thuê", en: "Rental item"},
                    type: {vi: "Loại", en: "Type"},
                    location: {vi: "Vị trí", en: "Location"},
                    status: {vi: "Trạng thái", en: "Status"},
                    house_room_created: {vi: "Nhà/phòng cho thuê được tạo vào", en: "House/room for rent created on"},
                    house: {vi: "Nhà", en: "House"},
                    active: {vi: "Đang thực hiện", en: "Active"}
                },
                become_host: {
                    title: {vi: "Trở thành host", en: "Become a Host"},
                    register_title: {vi: "Đăng ký trở thành Host", en: "Register to Become a Host"},
                    notifications: {vi: "Thông báo", en: "Notifications"},
                    request_pending: {vi: "Yêu cầu đang chờ duyệt", en: "Request Pending Approval"},
                    pending_title: {vi: "Yêu cầu đang chờ duyệt", en: "Request Pending Approval"},
                    request_rejected: {vi: "Yêu cầu bị từ chối", en: "Request Rejected"},
                    step1_title: {vi: "Bước 1: Thông tin xác minh danh tính", en: "Step 1: Identity Verification Information"},
                    step1_desc: {vi: "Vui lòng cung cấp thông tin chi tiết để admin có thể xác minh danh tính của bạn.", en: "Please provide detailed information so admin can verify your identity."},
                    full_name: {vi: "Họ và tên", en: "Full Name"},
                    phone_number: {vi: "Số điện thoại", en: "Phone Number"},
                    permanent_address: {vi: "Địa chỉ thường trú", en: "Permanent Address"},
                    address_placeholder: {vi: "Nhập địa chỉ đầy đủ bao gồm số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố", en: "Enter full address including house number, street, ward/commune, district, province/city"},
                    id_type: {vi: "Loại giấy tờ tùy thân", en: "ID Type"},
                    select_id_type: {vi: "Chọn loại giấy tờ", en: "Select ID type"},
                    citizen_id: {vi: "Căn cước công dân", en: "Citizen ID Card"},
                    national_id: {vi: "Chứng minh nhân dân", en: "National ID Card"},
                    passport: {vi: "Hộ chiếu", en: "Passport"},
                    id_number: {vi: "Số giấy tờ tùy thân", en: "ID Number"},
                    bank_name: {vi: "Tên ngân hàng", en: "Bank Name"},
                    select_bank: {vi: "Chọn ngân hàng", en: "Select Bank"},
                    bank_account: {vi: "Số tài khoản ngân hàng", en: "Bank Account Number"},
                    work_experience: {vi: "Kinh nghiệm làm việc", en: "Work Experience"},
                    experience_placeholder: {vi: "Mô tả kinh nghiệm làm việc, nghề nghiệp hiện tại của bạn...", en: "Describe your work experience, current profession..."},
                    motivation: {vi: "Lý do muốn trở thành host", en: "Reason for becoming a host"},
                    motivation_placeholder: {vi: "Chia sẻ lý do và động lực của bạn khi muốn trở thành host...", en: "Share your reasons and motivation for wanting to become a host..."},
                    next: {vi: "Tiếp theo", en: "Next"},
                    step2_title: {vi: "Bước 2: Chọn dịch vụ bạn muốn cung cấp", en: "Step 2: Select the service you want to provide"},
                    accommodation: {vi: "Nơi lưu trú", en: "Accommodation"},
                    experience: {vi: "Trải nghiệm", en: "Experience"},
                    service: {vi: "Dịch vụ", en: "Service"},
                    message_admin: {vi: "Tin nhắn cho admin (tùy chọn)", en: "Message for admin (optional)"},
                    message_placeholder: {vi: "Hãy chia sẻ thêm về kinh nghiệm hoặc lý do bạn muốn trở thành host...", en: "Please share more about your experience or reasons for wanting to become a host..."},
                    back: {vi: "Quay lại", en: "Back"},
                    submit_request: {vi: "Gửi yêu cầu", en: "Submit Request"},
                    fill_required: {vi: "Vui lòng điền đầy đủ thông tin bắt buộc.", en: "Please fill in all required information."}
                },
                edit_listing: {
                    title: {vi: "Chỉnh sửa bài đăng", en: "Edit Listing"},
                    editor_title: {vi: "Trình chỉnh sửa bài đăng", en: "Listing Editor"},
                    your_rental: {vi: "Chỗ ở cho thuê của bạn", en: "Your rental property"},
                    guest_guide: {vi: "Hướng dẫn khi khách đến", en: "Guest arrival guide"},
                    delete_listing: {vi: "Xóa bài đăng", en: "Delete listing"},
                    edit_sections: {vi: "Mục chỉnh sửa", en: "Edit sections"},
                    edit_sections_desc: {vi: "Vui lòng chọn các mục dưới đây để chỉnh sửa.", en: "Please select the sections below to edit."},
                    photo_tour: {vi: "Tour tham quan qua ảnh", en: "Photo tour"},
                    bedroom_bed_bath: {vi: "1 phòng ngủ - 1 giường - 1 phòng tắm", en: "1 bedroom - 1 bed - 1 bathroom"},
                    photos: {vi: "ảnh", en: "photos"},
                    title_label: {vi: "Tiêu đề", en: "Title"},
                    property_type: {vi: "Loại chỗ ở", en: "Property type"},
                    entire_home: {vi: "Toàn bộ nhà - Nhà", en: "Entire home - House"},
                    pricing: {vi: "Định giá", en: "Pricing"},
                    per_night: {vi: "/đêm", en: "/night"},
                    view: {vi: "Xem", en: "View"},
                    save: {vi: "Lưu", en: "Save"},
                    photo_tour_desc: {vi: "Quản lý ảnh và bổ sung thông tin. Khách sẽ chỉ thấy tour tham quan của bạn nếu mỗi phòng đều đã có ảnh.", en: "Manage photos and add information. Guests will only see your photo tour if each room has photos."},
                    all_photos: {vi: "Tất cả ảnh", en: "All photos"},
                    add_photo: {vi: "Thêm ảnh", en: "Add photo"},
                    add_new_photo: {vi: "Thêm ảnh mới", en: "Add new photo"},
                    select_photos: {vi: "Chọn ảnh:", en: "Select photos:"},
                    selected_photos: {vi: "Ảnh đã chọn:", en: "Selected photos:"},
                    cancel: {vi: "Hủy", en: "Cancel"},
                    upload: {vi: "Tải lên", en: "Upload"},
                    edit_title: {vi: "Chỉnh sửa tiêu đề", en: "Edit title"},
                    title_label_form: {vi: "Tiêu đề:", en: "Title:"},
                    edit_pricing: {vi: "Chỉnh sửa định giá", en: "Edit pricing"},
                    price_per_night: {vi: "Giá mỗi đêm (VND):", en: "Price per night (VND):"},
                    weekend_price: {vi: "Giá cuối tuần (VND):", en: "Weekend price (VND):"},
                    weekly_discount: {vi: "Giảm giá theo tuần (%):", en: "Weekly discount (%):"},
                    photo_tour_feature: {vi: "Tính năng tạo tour tham quan qua ảnh sẽ được phát triển trong tương lai!", en: "Photo tour creation feature will be developed in the future!"},
                    select_photos_alert: {vi: "Vui lòng chọn ít nhất một ảnh!", en: "Please select at least one photo!"},
                    photos_added: {vi: "Ảnh đã được thêm vào danh sách. Nhấn \"Lưu\" để xác nhận thay đổi.", en: "Photos have been added to the list. Click \"Save\" to confirm changes."},
                    no_photos_save: {vi: "Không có ảnh mới để lưu!", en: "No new photos to save!"},
                    photos_saved: {vi: "Ảnh đã được lưu thành công!", en: "Photos saved successfully!"},
                    error_saving: {vi: "Có lỗi xảy ra khi lưu ảnh: ", en: "Error saving photos: "},
                    edit_photo_feature: {vi: "Chỉnh sửa ảnh số", en: "Edit photo"},
                    edit_photo_will_develop: {vi: " - Tính năng này sẽ được phát triển!", en: " - This feature will be developed!"},
                    save_successful: {vi: "Lưu thành công", en: "Save successful"},
                    save_failed: {vi: "Lưu không thành công", en: "Save failed"},
                    confirm_delete: {vi: "Bạn có chắc muốn xóa bài đăng này? Bài đăng sẽ bị ẩn khỏi trang web nhưng vẫn có thể khôi phục bởi Admin.", en: "Are you sure you want to delete this listing? The listing will be hidden from the website but can be restored by Admin."},
                    listing_deleted: {vi: "Bài đăng đã được xóa thành công!", en: "Listing deleted successfully!"},
                    cannot_delete: {vi: "Không thể xóa bài đăng: ", en: "Cannot delete listing: "},
                    unknown_error: {vi: "Lỗi không xác định", en: "Unknown error"},
                    error_deleting: {vi: "Lỗi khi xóa bài đăng", en: "Error deleting listing"},
                    confirm_delete_photo: {vi: "Bạn có chắc muốn xoá ảnh này?", en: "Are you sure you want to delete this photo?"},
                    photo_deleted: {vi: "Đã xoá ảnh", en: "Photo deleted"},
                    cannot_delete_photo: {vi: "Không thể xoá ảnh: ", en: "Cannot delete photo: "},
                    error: {vi: "Lỗi", en: "Error"},
                    error_deleting_photo: {vi: "Lỗi khi xoá ảnh", en: "Error deleting photo"}
                },
                create_listing: {
                    title: {vi: "Tạo nơi lưu trú", en: "Create Accommodation"},
                    title_label: {vi: "Tiêu đề", en: "Title"},
                    title_placeholder: {vi: "Căn hộ 2 phòng ngủ trung tâm", en: "2-bedroom apartment downtown"},
                    city: {vi: "Thành phố", en: "City"},
                    city_placeholder: {vi: "Đà Nẵng", en: "Da Nang"},
                    address: {vi: "Địa chỉ", en: "Address"},
                    address_placeholder: {vi: "12 Trần Phú, Hải Châu", en: "12 Tran Phu, Hai Chau"},
                    price_per_night: {vi: "Giá/đêm (VND)", en: "Price/night (VND)"},
                    max_guests: {vi: "Số khách tối đa", en: "Maximum guests"},
                    description_placeholder: {vi: "Mô tả chỗ ở, tiện nghi, nội quy...", en: "Describe the accommodation, amenities, rules..."},
                    photos_optional: {vi: "Ảnh (tùy chọn, có thể chọn nhiều ảnh)", en: "Photos (optional, can select multiple photos)"},
                    cancel: {vi: "Hủy", en: "Cancel"},
                    post_accommodation: {vi: "Đăng nơi lưu trú", en: "Post accommodation"}
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
            },

            // ===== EXPERIENCES =====
            experiences: {
                title: {vi: "Trải nghiệm", en: "Experiences"},
                search_result: {vi: "Kết quả tìm kiếm", en: "Search results"},
                found_experiences: {vi: "Tìm thấy", en: "Found"},
                experiences_count: {vi: "trải nghiệm", en: "experiences"},
                go2bnb_original: {vi: "GO2BNB Original", en: "GO2BNB Original"},
                tomorrow_danang: {vi: "Ngày mai, tại Đà Nẵng", en: "Tomorrow in Da Nang"},
                local_food: {vi: "Ẩm thực địa phương", en: "Local Cuisine"},
                workshops_classes: {vi: "Workshop và lớp học", en: "Workshops & Classes"},
                from_price: {vi: "Từ", en: "From"},
                per_guest: {vi: "/khách", en: "/guest"},
                wishlist_feature: {vi: "Chức năng yêu thích đang phát triển!", en: "Favorite feature is under development!"}
            },

            // ===== PROFILE =====
            profile: {
                title: {vi: "Hồ sơ", en: "Profile"},
                edit_profile: {vi: "Chỉnh sửa hồ sơ", en: "Edit Profile"},
                save: {vi: "Lưu", en: "Save"},
                cancel: {vi: "Hủy", en: "Cancel"},
                user_profile: {vi: "Hồ sơ người dùng", en: "User Profile"},
                role: {vi: "Vai trò:", en: "Role:"},
                contact_info: {vi: "Thông tin liên lạc", en: "Contact Information"},
                email: {vi: "Email", en: "Email"},
                phone_number: {vi: "Số điện thoại", en: "Phone Number"},
                not_provided: {vi: "Not provided", en: "Not provided"},
                detailed_info: {vi: "Thông tin chi tiết", en: "Detailed Information"},
                joined_since: {vi: "Tham gia từ", en: "Joined since"},
                account_status: {vi: "Trạng thái tài khoản", en: "Account Status"},
                active: {vi: "Active", en: "Active"},
                inactive: {vi: "Inactive", en: "Inactive"},
                permissions_roles: {vi: "Quyền & Vai trò", en: "Permissions & Roles"},
                role_info: {vi: "Thông tin vai trò được hiển thị ở tiêu đề hồ sơ phía trên.", en: "Role information is displayed in the profile header above."},
                update_success: {vi: "Cập nhật thành công", en: "Update Successful"},
                avatar_updated: {vi: "Đã cập nhật ảnh đại diện thành công!", en: "Avatar updated successfully!"},
                remove_avatar: {vi: "Xóa ảnh", en: "Remove Avatar"},
                confirm_remove_avatar: {vi: "Bạn có chắc muốn xóa ảnh đại diện?", en: "Are you sure you want to remove your avatar?"},
                upload_error: {vi: "Lỗi: Không thể upload ảnh", en: "Error: Cannot upload image"},
                upload_error_msg: {vi: "Có lỗi khi tải ảnh đại diện. Vui lòng thử lại.", en: "Error uploading avatar. Please try again."},
                remove_error: {vi: "Xóa ảnh thất bại!", en: "Failed to remove avatar!"},
                personal_info: {vi: "Thông tin cá nhân", en: "Personal Information"},
                full_name: {vi: "Họ & tên", en: "Full Name"},
                required: {vi: "*", en: "*"},
                name_required: {vi: "Cần phải nhập đầy đủ họ tên.", en: "Please enter your full name."},
                email_required: {vi: "Vui lòng nhập địa chỉ email.", en: "Please enter your email address."},
                phone_optional: {vi: "Số điện thoại (không bắt buộc)", en: "Phone Number (optional)"},
                account_settings: {vi: "Cài đặt tài khoản", en: "Account Settings"},
                account_status_label: {vi: "Trạng thái tài khoản", en: "Account Status"},
                account_status_desc: {vi: "Kích hoạt hoặc hủy kích hoạt tài khoản này", en: "Activate or deactivate this account"},
                change_password: {vi: "Thay đổi mật khẩu", en: "Change Password"},
                current_password: {vi: "Nhập mật khẩu hiện tại", en: "Enter current password"},
                new_password: {vi: "Nhập mật khẩu mới", en: "Enter new password"},
                confirm_password: {vi: "Xác nhận mật khẩu mới", en: "Confirm new password"},
                password_note: {vi: "Note: Để trống trường mật khẩu nếu bạn không muốn thay đổi mật khẩu.", en: "Note: Leave password fields empty if you don't want to change your password."},
                cancel_changes: {vi: "Hủy bỏ", en: "Cancel"},
                save_changes: {vi: "Lưu thay đổi", en: "Save Changes"},
                saving: {vi: "Đang lưu...", en: "Saving..."},
                success: {vi: "Success", en: "Success"},
                profile_updated: {vi: "Hồ sơ đã được cập nhật thành công!", en: "Profile updated successfully!"},
                error: {vi: "Error", en: "Error"},
                update_error: {vi: "Đã xảy ra lỗi khi cập nhật hồ sơ.", en: "An error occurred while updating profile."},
                current_password_required: {vi: "Vui lòng nhập mật khẩu hiện tại", en: "Please enter current password"},
                new_password_required: {vi: "Vui lòng nhập mật khẩu mới", en: "Please enter new password"},
                password_min_length: {vi: "Mật khẩu mới phải có ít nhất 6 ký tự", en: "New password must be at least 6 characters"},
                confirm_password_required: {vi: "Vui lòng xác nhận mật khẩu mới của bạn", en: "Please confirm your new password"},
                password_mismatch: {vi: "Mật khẩu không khớp", en: "Passwords do not match"}
            },

            // ===== BOOKING =====
            booking: {
                title: {vi: "Đặt phòng", en: "Booking"},
                booking_form: {vi: "Mẫu đặt phòng", en: "Booking Form"},
                booking_list: {vi: "Danh sách đặt phòng", en: "Booking List"},
                booking_detail: {vi: "Chi tiết đặt phòng", en: "Booking Detail"},
                payment_result: {vi: "Kết quả thanh toán", en: "Payment Result"},
                check_in: {vi: "Nhận phòng", en: "Check-in"},
                check_out: {vi: "Trả phòng", en: "Check-out"},
                guests: {vi: "Khách", en: "Guests"},
                total_price: {vi: "Tổng giá", en: "Total Price"},
                pay_now: {vi: "Thanh toán ngay", en: "Pay Now"},
                continue_payment: {vi: "Tiếp tục thanh toán", en: "Continue Payment"},
                price_per_night: {vi: "Giá/đêm", en: "Price/night"},
                max_guests: {vi: "Tối đa", en: "Max"},
                nights: {vi: "Số đêm", en: "Nights"},
                total_amount: {vi: "Tổng cộng", en: "Total"},
                guest_bookings: {vi: "Đặt phòng của khách", en: "Guest Bookings"},
                my_bookings: {vi: "Đặt phòng của tôi", en: "My Bookings"},
                no_bookings: {vi: "Chưa có đặt phòng nào", en: "No bookings yet"},
                no_guest_bookings: {vi: "Chưa có khách nào đặt phòng của bạn", en: "No guests have booked your rooms"},
                no_my_bookings: {vi: "Bạn chưa đặt phòng nào", en: "You haven't booked any rooms"},
                find_rooms: {vi: "Tìm phòng ngay", en: "Find Rooms Now"},
                home_page: {vi: "Về trang chủ", en: "Home"},
                check_in_date: {vi: "Ngày nhận phòng", en: "Check-in Date"},
                check_out_date: {vi: "Ngày trả phòng", en: "Check-out Date"},
                number_of_guests: {vi: "Số khách", en: "Number of Guests"},
                guest_count: {vi: "khách", en: "guests"},
                room_deleted: {vi: "Phòng đã bị xóa", en: "Room deleted"},
                address_unavailable: {vi: "Địa chỉ không khả dụng", en: "Address unavailable"},
                guest_name: {vi: "Khách:", en: "Guest:"},
                status_processing: {vi: "Đang xử lý", en: "Processing"},
                status_completed: {vi: "Hoàn thành", en: "Completed"},
                status_failed: {vi: "Thất bại", en: "Failed"},
                details: {vi: "Chi tiết", en: "Details"},
                cancel: {vi: "Hủy", en: "Cancel"},
                confirm_cancel: {vi: "Bạn có chắc muốn hủy đặt phòng này?", en: "Are you sure you want to cancel this booking?"},
                room_info: {vi: "Thông tin phòng", en: "Room Information"},
                room_name: {vi: "Tên phòng:", en: "Room Name:"},
                address: {vi: "Địa chỉ:", en: "Address:"},
                nights_count: {vi: "đêm", en: "nights"},
                guest_info: {vi: "Thông tin khách", en: "Guest Information"},
                guest_name_label: {vi: "Tên:", en: "Name:"},
                status_info: {vi: "Trạng thái", en: "Status"},
                booking_status: {vi: "Đặt phòng:", en: "Booking:"},
                payment_status: {vi: "Thanh toán:", en: "Payment:"},
                payment_success: {vi: "Thành công", en: "Success"},
                payment_failed: {vi: "Thất bại", en: "Failed"},
                payment_pending: {vi: "Chờ xử lý", en: "Pending"},
                payment_refunded: {vi: "Đã hoàn tiền", en: "Refunded"},
                amount: {vi: "Số tiền:", en: "Amount:"},
                payment_date: {vi: "Ngày thanh toán:", en: "Payment Date:"},
                booking_date: {vi: "Ngày đặt:", en: "Booking Date:"},
                payment_section: {vi: "Thanh toán", en: "Payment"},
                not_paid: {vi: "Chưa thanh toán hoặc thanh toán thất bại", en: "Not paid or payment failed"},
                pay_now_button: {vi: "Thanh toán ngay", en: "Pay Now"},
                payment_processing: {vi: "Đang chờ xử lý thanh toán", en: "Payment processing"},
                payment_success_msg: {vi: "Đã thanh toán thành công", en: "Payment successful"},
                cancel_booking: {vi: "Hủy đặt phòng", en: "Cancel Booking"},
                can_cancel: {vi: "Bạn có thể hủy đặt phòng này", en: "You can cancel this booking"},
                confirm_cancel_booking: {vi: "Bạn có chắc muốn hủy đặt phòng này?", en: "Are you sure you want to cancel this booking?"},
                admin_management: {vi: "Quản lý (Admin)", en: "Management (Admin)"},
                confirm_booking: {vi: "Xác nhận đặt phòng", en: "Confirm Booking"},
                cancel_booking_admin: {vi: "Hủy đặt phòng", en: "Cancel Booking"},
                restore_booking: {vi: "Khôi phục đặt phòng", en: "Restore Booking"},
                back_dashboard: {vi: "Quay lại Dashboard", en: "Back to Dashboard"},
                list_bookings: {vi: "Danh sách", en: "List"},
                home: {vi: "Trang chủ", en: "Home"},
                success: {vi: "Thành công", en: "Success"},
                error: {vi: "Lỗi", en: "Error"},
                missing_info: {vi: "Thiếu thông tin", en: "Missing Information"},
                missing_dates: {vi: "Vui lòng chọn ngày check-in và check-out!", en: "Please select check-in and check-out dates!"},
                invalid_dates: {vi: "Ngày không hợp lệ", en: "Invalid Dates"},
                check_out_after_check_in: {vi: "Ngày check-out phải sau ngày check-in!", en: "Check-out date must be after check-in date!"},
                date_already_booked: {vi: "Ngày đã được đặt", en: "Date Already Booked"},
                room_booked_period: {vi: "Phòng này đã được đặt từ", en: "This room is already booked from"},
                to: {vi: "đến", en: "to"},
                please_choose_other: {vi: "Vui lòng chọn ngày khác.", en: "Please choose other dates."},
                understood: {vi: "Đã hiểu", en: "Understood"},
                cannot_book_own: {vi: "Không thể đặt phòng", en: "Cannot Book"},
                cannot_book_own_msg: {vi: "Bạn không thể đặt phòng của chính mình!", en: "You cannot book your own room!"},
                room_already_booked: {vi: "Phòng đã được đặt trong khoảng thời gian này. Vui lòng chọn ngày khác.", en: "Room is already booked during this period. Please choose other dates."},
                check_in_past: {vi: "Ngày check-in không thể trong quá khứ!", en: "Check-in date cannot be in the past!"},
                invalid_range: {vi: "Ngày check-out phải sau ngày check-in!", en: "Check-out date must be after check-in date!"}
            },

            // ===== SIDEBAR =====
            sidebar: {
                wishlist: {vi: "Danh sách yêu thích", en: "Wishlist"},
                trips: {vi: "Chuyến đi", en: "Trips"},
                notifications: {vi: "Thông báo", en: "Notifications"}
            },

            // ===== CHAT =====
            chat: {
                title: {vi: "Tin nhắn", en: "Messages"},
                chat_detail: {vi: "Chi tiết tin nhắn", en: "Chat Detail"},
                send_message: {vi: "Gửi tin nhắn", en: "Send message"},
                type_message: {vi: "Nhập tin nhắn...", en: "Type a message..."},
                go_back: {vi: "Quay lại", en: "Go back"},
                search_conversations: {vi: "Tìm kiếm cuộc hội thoại...", en: "Search conversations..."},
                no_messages: {vi: "Bạn không có tin nhắn nào", en: "You have no messages"},
                no_messages_desc: {vi: "Khi bạn nhắn tin với host, các cuộc hội thoại sẽ xuất hiện ở đây.", en: "When you message hosts, conversations will appear here."},
                search_accommodations: {vi: "Tìm kiếm nơi lưu trú", en: "Search accommodations"},
                host: {vi: "Host", en: "Host"},
                guest: {vi: "Guest", en: "Guest"},
                no_messages_yet: {vi: "Chưa có tin nhắn nào", en: "No messages yet"},
                first_message: {vi: "Hãy gửi tin nhắn đầu tiên để bắt đầu cuộc hội thoại!", en: "Send your first message to start the conversation!"},
                typing: {vi: "Đang nhập...", en: "Typing..."},
                delete_conversation: {vi: "Xóa cuộc trò chuyện", en: "Delete conversation"},
                confirm_delete: {vi: "Xóa cuộc trò chuyện?", en: "Delete conversation?"},
                confirm_delete_desc: {vi: "Bạn có chắc muốn xóa cuộc trò chuyện này không?Tin nhắn sẽ bị ẩn khỏi hộp thoại của bạn.", en: "Are you sure you want to delete this conversation? Messages will be hidden from your inbox."},
                delete: {vi: "Xóa", en: "Delete"},
                cancel: {vi: "Hủy", en: "Cancel"},
                deleting: {vi: "Đang xóa...", en: "Deleting..."},
                please_wait: {vi: "Vui lòng đợi", en: "Please wait"},
                deleted: {vi: "Đã xóa!", en: "Deleted!"},
                delete_success: {vi: "Cuộc trò chuyện đã được xóa thành công.", en: "Conversation has been deleted successfully."},
                error: {vi: "Lỗi!", en: "Error!"},
                delete_error: {vi: "Không thể xóa cuộc trò chuyện. Vui lòng thử lại.", en: "Cannot delete conversation. Please try again."},
                delete_error_general: {vi: "Đã xảy ra lỗi khi xóa cuộc trò chuyện. Vui lòng thử lại.", en: "An error occurred while deleting the conversation. Please try again."}
            },

            // ===== EXPERIENCE DETAIL =====
            experience_detail: {
                location: {vi: "Địa điểm", en: "Location"},
                meeting_location: {vi: "Địa điểm hẹn gặp", en: "Meeting location"},
                note_label: {vi: "Lưu ý:", en: "Note:"},
                note_text: {vi: "Địa điểm chính xác sẽ được gửi qua email sau khi đặt chỗ thành công.", en: "The exact meeting location will be sent via email after successful booking."},
                what_included: {vi: "Bao gồm", en: "What's included"},
                meeting_point: {vi: "Điểm hẹn gặp", en: "Meeting point"},
                back_button: {vi: "Quay lại", en: "Go back"},
                contact_message: {vi: "Xin chào! Tôi muốn tư vấn về trải nghiệm", en: "Hello! I would like to consult about the experience"},
                price: {vi: "Giá", en: "Price"},
                contact_request: {vi: "Vui lòng liên hệ tôi để biết thêm chi tiết và đặt phòng kèm trải nghiệm này.", en: "Please contact me for more details and to book accommodation with this experience."}
            },

            // ===== SERVICES =====
            services: {
                page_title: {vi: "Dịch vụ", en: "Services"},
                minimum: {vi: "Tối thiểu", en: "Minimum"},
                view_details: {vi: "Xem chi tiết", en: "View Details"},
                book_now: {vi: "Đặt ngay", en: "Book Now"},
                no_services: {vi: "Không có dịch vụ nào", en: "No services available"},
                no_services_desc: {vi: "Hiện tại chưa có dịch vụ nào được cung cấp.", en: "Currently no services are available."}
            },

            // ===== HOME =====
            home: {
                title: {vi: "Trang chủ", en: "Home"},
                card: {
                    view_detail: {vi: "Xem chi tiết", en: "View Details"},
                    book_now: {vi: "Đặt ngay", en: "Book Now"},
                    max_guests: {vi: "Tối đa", en: "Max"},
                    guests: {vi: "khách", en: "guests"},
                    per_night: {vi: "/đêm", en: "/night"}
                }
            },

            // ===== RESET PASSWORD =====
            resetpass: {
                forgot_title: {vi: "Quên mật khẩu", en: "Forgot Password"},
                reset_title: {vi: "Đặt lại mật khẩu", en: "Reset Password"},
                email_sent_title: {vi: "Email đã được gửi", en: "Email Sent"},
                enter_email: {vi: "Nhập email của bạn", en: "Enter your email"},
                send_reset_link: {vi: "Gửi liên kết đặt lại", en: "Send Reset Link"},
                new_password: {vi: "Mật khẩu mới", en: "New Password"},
                confirm_password: {vi: "Xác nhận mật khẩu", en: "Confirm Password"},
                reset_password: {vi: "Đặt lại mật khẩu", en: "Reset Password"},
                check_email: {vi: "Kiểm tra email của bạn", en: "Check your email"},
                email_sent_desc: {vi: "Chúng tôi đã gửi liên kết đặt lại mật khẩu đến email của bạn.", en: "We've sent a password reset link to your email."},
                back_to_login: {vi: "Quay lại đăng nhập", en: "Back to Login"}
            },

            // ===== SERVICE DETAIL =====
            service_detail: {
                title: {vi: "Chi tiết dịch vụ", en: "Service Detail"},
                provider_info: {vi: "Thông tin nhà cung cấp", en: "Provider Information"},
                provider_title: {vi: "Nhà cung cấp dịch vụ chuyên nghiệp", en: "Professional Service Provider"},
                verified: {vi: "Đã xác minh dịch vụ", en: "Verified service"},
                category: {vi: "Danh mục:", en: "Category:"},
                status: {vi: "Trạng thái:", en: "Status:"},
                created_at: {vi: "Ngày tạo:", en: "Created:"},
                per_guest: {vi: "/ khách", en: "/ guest"},
                unknown: {vi: "Không xác định", en: "Unknown"}
            }
        },

        // ================= CORE =================
        setLang(l) {
            console.log('Setting language to:', l);
            I18N.lang = l;
            localStorage.setItem("lang", l);
            I18N.apply();
            document.documentElement.setAttribute("lang", l);
            I18N.updateBadge();
            I18N.convertAllPrices(); // Tự động chuyển đổi giá tiền
            console.log('Language set to:', l, 'Applied translations and converted prices');
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
            const flag = badge.querySelector("[data-lang-flag]");
            const text = I18N.lang === "vi" ? "Tiếng Việt" : "English";
            const flagEmoji = I18N.lang === "vi" ? "🇻🇳" : "🇺🇸";
            if (label)
                label.textContent = text;
            if (flag)
                flag.textContent = flagEmoji;
        },

        // Format giá tiền và tự động chuyển đổi VND -> USD
        formatPrice(price) {
            if (typeof price !== 'number') {
                price = parseFloat(price) || 0;
            }
            
            if (I18N.lang === 'vi') {
                // Format theo chuẩn Việt Nam: 5.000.000 ₫
                return new Intl.NumberFormat('vi-VN').format(price) + ' ₫';
            } else {
                // Chuyển đổi VND sang USD (tỷ giá khoảng 24.500 VND = 1 USD)
                const usdPrice = price / 24500;
                // Format theo chuẩn quốc tế: $500
                return '$' + new Intl.NumberFormat('en-US', {maximumFractionDigits: 2}).format(usdPrice);
            }
        },

        // Tự động chuyển đổi tất cả giá tiền trên trang
        convertAllPrices() {
            const vndToUsdRate = 24500; // 1 USD = 24,500 VND
            
            // Xử lý các element có data-price attribute trước
            document.querySelectorAll('[data-price]').forEach(el => {
                const price = parseFloat(el.getAttribute('data-price')) || 0;
                const formattedPrice = I18N.formatPrice(price);
                el.textContent = formattedPrice;
            });
            
            // Tìm tất cả text chứa ₫ (chỉ xử lý text nodes)
            const walker = document.createTreeWalker(
                document.body,
                NodeFilter.SHOW_TEXT,
                null,
                false
            );
            
            let node;
            while (node = walker.nextNode()) {
                const text = node.textContent;
                if (text && text.includes('₫') && text.match(/\d/)) {
                    // Lưu text gốc
                    let originalText = node.getAttribute ? node.getAttribute('data-original-text') : null;
                    if (!originalText) {
                        originalText = text;
                        if (node.parentElement) {
                            node.parentElement.setAttribute('data-original-text', originalText);
                        }
                    }
                    
                    if (I18N.lang === 'en') {
                        // Chuyển ₫ sang $
                        const match = originalText.match(/(\d[\d\s,\.]*)\s*₫/);
                        if (match) {
                            let vndPrice = match[1];
                            // Parse số VND
                            vndPrice = vndPrice.replace(/\./g, '').replace(/\s/g, '').replace(/,/g, '');
                            const usdPrice = parseFloat(vndPrice) / vndToUsdRate;
                            const formattedPrice = new Intl.NumberFormat('en-US', {maximumFractionDigits: 2}).format(usdPrice);
                            node.textContent = originalText.replace(/[\d\s,\.]*\s*₫/, '$' + formattedPrice);
                        }
                    } else {
                        // Restore text gốc
                        node.textContent = originalText;
                    }
                }
            }
        },

        // áp text vào DOM
        apply(root) {
            const scope = root || document;

            scope.querySelectorAll("[data-i18n]").forEach((el) => {
                const key = el.getAttribute("data-i18n");
                const txt = I18N.t(key);
                if (txt && txt !== key) { // Chỉ thay đổi nếu có translation
                    if (el.tagName === "INPUT" || el.tagName === "TEXTAREA")
                        el.value = txt;
                    else
                        el.textContent = txt;
                }
            });

            // Format giá tiền cho các element có data-price
            scope.querySelectorAll("[data-price]").forEach((el) => {
                const price = el.getAttribute("data-price");
                const formattedPrice = I18N.formatPrice(price);
                el.textContent = formattedPrice;
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
          <button class="lang-modal__close" aria-label="${I18N.t("common.close")}" data-close="1">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
          <div class="lang-modal__header">
            <h2 id="lang-modal-title" class="lang-modal__title" data-i18n="common.choose_language"></h2>
            <div class="lang-modal__auto">
              <span class="lang-modal__auto-title">Bản dịch</span>
              <label class="lang-switch">
                <input type="checkbox" id="auto-vi"><span class="lang-switch__slider"></span>
              </label>
            </div>
            <div class="lang-modal__auto-help" data-i18n="common.translation_autoswitch_help"></div>
          </div>
          <div class="lang-modal__grid">
            <button class="lang-option" data-lang="vi">
              <span class="lang-option__flag">🌐</span>
              <span>Tiếng Việt (VN)</span>
            </button>
            <button class="lang-option" data-lang="en">
              <span class="lang-option__flag">🌐</span>
              <span>English (EN)</span>
            </button>
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
        // mở modal
        showModal() {
            I18N.ensureModal();
            const el = document.getElementById("lang-modal");
            el.style.display = "block";
            document.documentElement.style.overflow = "hidden";

            // Thêm hiệu ứng fade in
            requestAnimationFrame(() => {
                el.classList.add('show');
            });
        },

        hideModal() {
            const el = document.getElementById("lang-modal");
            if (!el)
                return;

            // Thêm hiệu ứng fade out
            el.classList.remove('show');
            setTimeout(() => {
            el.style.display = "none";
            document.documentElement.style.overflow = "";
            }, 300);
        },

        // init
        init() {
            I18N.ensureModal();
            I18N.apply();
            console.log('I18N initialized, current lang:', I18N.lang);

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
