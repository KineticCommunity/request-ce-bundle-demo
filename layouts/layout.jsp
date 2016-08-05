<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, maximum-scale=1.0">
        <link rel="apple-touch-icon" sizes="76x76" href="${bundle.location}/images/apple-touch-icon.png">
        <link rel="icon" type="image/png" href="${bundle.location}/images/android-chrome-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="${bundle.location}/images/favicon-16x16.png" sizes="16x16">
        <link rel="icon" type="image/png" href="${bundle.location}/images/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="${bundle.location}/images/favicon-96x96.png" sizes="96x96">
        <link rel="shortcut icon" href="${bundle.location}/images/favicon.ico" type="image/x-icon"/>
        <app:headContent/>
        <link href="${bundle.location}/libraries/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
        <bundle:stylepack>
            <bundle:style src="${bundle.location}/libraries/bootstrap/css/bootstrap.min.css"/>   
            <bundle:style src="${bundle.location}/libraries/jquery-datatables/media/css/jquery.dataTables.css" />
            <bundle:style src="${bundle.location}/libraries/jquery-datatables/extensions/Responsive/css/responsive.dataTables.css" />
          
            <bundle:style src="${bundle.location}/libraries/notifie/jquery.notifie.css"/>
            <c:choose>
                <c:when test="${not empty themeBundlePathModifier}">
                    <bundle:style src="${bundle.location}${themeBundlePathModifier}/css/master.css"/>
                </c:when>
                <c:otherwise>
                    <bundle:style src="${bundle.location}/libraries/AdminLTE-Sass/build/master.css"/>
                </c:otherwise>
            </c:choose>
            <bundle:style src="${bundle.location}/css/custom.css"/>
            <bundle:style src="${bundle.location}/libraries/kd-typeahead/kd-typeahead.css"/>
        </bundle:stylepack>
        <bundle:scriptpack>
            <bundle:script src="${bundle.location}/libraries/jquery/jquery.min.js" />
            <bundle:script src="${bundle.location}/libraries/underscore/underscore.js"/>
            <bundle:script src="${bundle.location}/libraries/moment/moment.js" />
            <bundle:script src="${bundle.location}/libraries/moment/moment-timezone.js" />
            <bundle:script src="${bundle.location}/libraries/jquery-datatables/media/js/jquery.dataTables.js" />
            <bundle:script src="${bundle.location}/libraries/jquery-datatables/extensions/Responsive/js/dataTables.responsive.js" />
            <bundle:script src="${bundle.location}/libraries/kd-search/search.js"/>
            <bundle:script src="${bundle.location}/libraries/kd-typeahead/kd-typeahead.js"/>
            <bundle:script src="${bundle.location}/libraries/kd-subforms/kd-subforms.js"/>
            <bundle:script src="${bundle.location}/libraries/bootstrap/js/bootstrap.min.js"/>
            <bundle:script src="${bundle.location}/libraries/notifie/jquery.notifie.js"/>
            <bundle:script src="${bundle.location}/libraries/typeahead/typeahead.min.js"/>
            <bundle:script src="${bundle.location}/js/catalog.js"/>
            <bundle:script src="${bundle.location}/js/locking.js" />
            <bundle:script src="${bundle.location}/js/review.js"/>
            <bundle:script src="${bundle.location}/libraries/AdminLTE-Sass/build/js/app.min.js"/>
        </bundle:scriptpack>
        <bundle:yield name="head"/>
        <style>
            <c:if test="${not empty kapp.getAttributeValue('Logo Height Px')}">
                .navbar-brand {height:${kapp.getAttributeValue('Logo Height Px')}px;}
            </c:if>
        </style>
        <c:set scope="session" var="activePage" value="${BundleHelper.getActivePage(param.page, param.category, param.type)}"/>
    </head>
    <c:choose>
        <c:when test="${identity.anonymous}">
            <body class="hold-transition login-page">
                <div class="login-box">
                    <bundle:yield/>
                </div>
            </body>
        </c:when>
        <c:otherwise>
            <body class="hold-transition skin-purple-light sidebar-mini">
                <div class="wrapper">
                    <c:import url="${bundle.path}${themeBundlePathModifier}/partials/header.jsp" charEncoding="UTF-8"/>
                    <c:import url="${bundle.path}/partials/sidebar.jsp" charEncoding="UTF-8"/>
                    <div class="content-wrapper">
                        <bundle:yield/>
                    </div>
                    <c:import url="${bundle.path}${themeBundlePathModifier}/partials/footer.jsp" charEncoding="UTF-8"/>
                </div>
            </body>
        </c:otherwise>
    </c:choose>
    <script>
        window.identity = '${identity.username}';
    </script>
</html>
<script>
    window.identity = '${identity.username}';
</script>