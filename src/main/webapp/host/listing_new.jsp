<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/go2bnb_host.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/lang_modal.css">
  <title>Create Accommodation</title>
  <script src="${pageContext.request.contextPath}/js/i18n.js"></script>
  <style>
    .wrap{max-width:980px;margin:32px auto;padding:0 16px;}
    form{display:grid;grid-template-columns:1fr 1fr;gap:24px;}
    label{display:block;font-weight:600;margin-bottom:8px;}
    input[type=text], input[type=number], textarea{
      width:100%;padding:12px;border:1px solid #ddd;border-radius:12px;
    }
    textarea{min-height:140px;grid-column:1/-1;}
    .full{grid-column:1/-1;}
    .actions{display:flex;justify-content:flex-end;gap:12px;grid-column:1/-1;margin-top:8px;}
    .btn{padding:12px 18px;border-radius:999px;border:1px solid #111;background:#111;color:#fff;font-weight:600;}
    .photos{grid-column:1/-1;border:1px dashed #ccc;border-radius:12px;padding:16px;}
    .error{background:#fff0f0;color:#b42318;padding:12px 16px;border-radius:12px;margin-bottom:16px;}
  </style>
</head>
<body>
<div class="wrap">
  <h2 data-i18n="host.create_listing.title">Create Accommodation</h2>

  <c:if test="${not empty errors}">
    <div class="error">
      <ul style="margin:0 0 0 18px;">
        <c:forEach var="e" items="${errors}"><li>${e}</li></c:forEach>
      </ul>
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/host/listing/new" method="post" enctype="multipart/form-data">
    <div class="full">
      <label>Title</label>
      <input type="text" name="title" placeholder="2-bedroom apartment downtown" required>
    </div>

    <div>
      <label>City</label>
      <input type="text" name="city" placeholder="Da Nang" required>
    </div>
    <div>
      <label>Address</label>
      <input type="text" name="address" placeholder="12 Tran Phu, Hai Chau">
    </div>

    <div>
      <label>Price/night (VND)</label>
      <input type="number" name="pricePerNight" min="1" step="1" required>
    </div>
    <div>
      <label>Maximum guests</label>
      <input type="number" name="maxGuests" min="1" step="1" value="1" required>
    </div>

    <textarea name="description" placeholder="Describe the accommodation, amenities, rules..."></textarea>

    <div class="photos">
      <label>Photos (optional, can select multiple photos)</label><br>
      <input type="file" name="images" accept="image/*" multiple>
    </div>

    <div class="actions">
      <a class="btn" style="background:#fff;color:#111" href="${pageContext.request.contextPath}/host/listings">Cancel</a>
      <button class="btn" type="submit">Post accommodation</button>
    </div>
  </form>
</div>

<!-- Language Selector Button -->
<div style="position: fixed; bottom: 20px; right: 20px; z-index: 1000;">
    <button data-open-lang-modal style="background: #ff5a5f; color: white; border: none; padding: 12px 16px; border-radius: 50px; cursor: pointer; box-shadow: 0 4px 12px rgba(0,0,0,0.15); font-size: 14px; font-weight: 500;">
        🌐 <span data-lang-label>English</span>
    </button>
</div>

<script>
    // Update language button text
    document.addEventListener('DOMContentLoaded', function() {
        function updateLangButton() {
            const langLabel = document.querySelector('[data-lang-label]');
            if (langLabel && window.I18N) {
                const currentLang = window.I18N.lang || 'en';
                langLabel.textContent = currentLang === 'vi' ? 'Tiếng Việt' : 'English';
            }
        }
        
        // Update on page load
        updateLangButton();
        
        // Listen for language changes
        const originalSetLang = window.I18N?.setLang;
        if (originalSetLang) {
            window.I18N.setLang = function(lang) {
                originalSetLang.call(this, lang);
                updateLangButton();
            };
        }
    });
</script>
</body>
</html>