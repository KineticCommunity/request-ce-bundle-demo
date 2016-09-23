<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<c:if test="${BundleHelper.hasForm('admin','broadcast-alerts')}">
    <c:set var="broadcastAlerts" value="${BridgedResourceHelper.search('Broadcast Alerts - All')}"/>
</c:if>
<c:set var="pendingApprovals" value="${SubmissionHelper.retrieveDraftApprovals()}"/>
<header class="main-header">
    <!-- Logo -->
    <a href="${bundle.kappLocation}" class="logo">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini">
            <i class="fa fa-home"></i>
        </span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg">
            <c:choose>
                <%-- Check to See if Company Logo / Name Attributes Exists --%>
                <c:when test="${not empty space.getAttribute('Company Logo') && not empty kapp.getAttribute('Company Logo')}">
                    <img class="pull-left" src="${BundleHelper.getLogo(kapp)}" alt="logo" style="display:block; max-height:40px; margin:5px;">
                    <strong class="pull-right">
                        <c:choose>
                            <c:when test="${not empty space.getAttribute('Company Logo')}">
                                ${space.getAttributeValue('Company Logo')}
                                <div class="small">${kapp.name}</div>
                            </c:when>
                            <c:otherwise>
                                ${kapp.name}
                            </c:otherwise>
                        </c:choose>
                    </strong>
                </c:when>
                <%-- If no logo attribute exists, display the Company or KAPP Name --%>
                <c:otherwise>
                    <i class="fa fa-home"></i> 
                    <c:choose>
                        <c:when test="${not empty space.getAttribute('Company Name')}">
                           ${space.getAttributeValue('Company Name')}
                           <div class="small">${kapp.name}</div>
                        </c:when>
                        <c:otherwise>
                            ${kapp.name}
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </span>
    </a>

    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top" role="navigation">
        <!-- Sidebar toggle button-->
        <a href="#" class="sidebar-toggle hidden-lg hidden-md hidden-sm" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
        </a>
        <!-- Navbar Right Menu -->
        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">

                <!-- Notifications: style can be found in dropdown.less -->
                <c:if test="${fn:length(broadcastAlerts) > 0}">
                    <li class="dropdown messages-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-bell-o"></i>
                            <c:if test="${fn:length(broadcastAlerts) > 0}">
                                <span class="label label-warning">${fn:length(broadcastAlerts)}</span>
                            </c:if>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">You have ${fn:length(broadcastAlerts)} notifications</li>
                            <li>
                            <!-- inner menu: contains the actual data -->
                                <ul class="menu">
                                    <c:forEach var="broadcastAlert" items="${broadcastAlerts}">
                                        <li><!-- start message -->
                                            <a href="#">
                                                <div class="pull-left">
                                                  <i class="fa fa-warning text-yellow" alt="Alert"></i>
                                                </div>
                                                <h4>
                                                    ${broadcastAlert.get('Subject')}
                                                    <div>
                                                        <small>
                                                            <i class="fa fa-clock-o"></i>
                                                            <span data-moment>${broadcastAlert.get('createdAt')}</span>
                                                        </small>
                                                    </div>
                                                </h4>
                                                <p>${broadcastAlert.get('Message')}</p>
                                            </a>
                                        </li><!-- end message -->
                                    </c:forEach>
                                </ul>
                            </li>
                            <li class="footer"><a href="#"></a></li>
                        </ul>
                    </li>
                </c:if>
                <!-- Tasks: style can be found in dropdown.less -->
                <c:if test="${fn:length(pendingApprovals) > 0}">
                    <li class="dropdown tasks-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-thumbs-o-up"></i>
                            <c:if test="${fn:length(pendingApprovals) > 0}">
                                <span class="label label-danger">${fn:length(pendingApprovals)}</span>
                            </c:if>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">You have ${fn:length(pendingApprovals)} Approvals Pending</li>
                            <li>
                                <!-- inner menu: contains the actual data -->
                                <ul class="menu">
                                    <c:forEach var="approval" items="${pendingApprovals}">
                                        <li><!-- Task item -->
                                            <a href="${bundle.spaceLocation}/submissions/${approval.id}">
                                                <h3>
                                                    ${Submissions.retrieve(approval.getValue('Parent Instance ID')).form.name}
                                                </h3>
                                                <h3>
                                                    <span>${approval.label}</span>
                                                </h3>
                                            </a>
                                        </li><!-- end task item -->
                                    </c:forEach>
                                </ul>
                            </li>
                            <li class="footer">
                                <a href="${bundle.kappLocation}?page=submissions&type=approval">View all Approvals</a>
                            </li>
                        </ul>
                    </li>
                </c:if>
                <li class="dropdown kapps-menu">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-th"></i>
                    </a>
                    <ul class="dropdown-menu">
                        <c:forEach var="spaceKapp" items="${space.kapps}">
                            <li><!-- start message -->
                                <a href="${bundle.spaceLocation}/${spaceKapp.slug}/">  
                                    <i class="fa ${spaceKapp.getAttributeValue("Icon")} fa-fw fa-1x"></i>
                                    <span>${spaceKapp.name}</span>
                                </a>
                            </li><!-- end message -->
                        </c:forEach>
                        <c:if test="${identity.spaceAdmin}">
                            <li class="divider hidden-xs"></li>
                            <li class="hidden-xs"><a href="${bundle.spaceLocation}/app/#/${kapp.slug}/activity/overview">
                                <i class="fa fa-dashboard fa-fw"></i> Management Console</a>
                            </li>
                        </c:if>
                    </ul>
                </li>
                <c:choose>
                    <c:when test="${identity.anonymous}">
                        <a href="${bundle.spaceLocation}/app/login" class="hidden-xs"><i class="fa fa-sign-in fa-fw"></i> Login</a>
                    </c:when>
                    <c:otherwise>
                        <!-- User Account: style can be found in dropdown.less -->
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="user-image fa fa-user fa-2x" alt="User Image"></i>
                                <span class="hidden-xs"> ${text.escape(text.trim(identity.displayName, identity.username))} </span>
                            </a>
                            <ul class="dropdown-menu">
                                <!-- User image -->
                                <li class="user-header">
                                    <i class="fa fa-user fa-5x fa-inverse img-circle" alt="User Image"></i>
                                    <p>
                                        ${text.escape(text.trim(identity.displayName, identity.username))} 
                                        <small>Member since <span data-moment-short>${time.format(identity.user.createdAt)}</span></small>
                                    </p>
                                </li>
                                <!-- Menu Footer-->
                                <li class="user-footer">
                                    <div class="pull-left">
                                        <a href="${bundle.spaceLocation}/${kapp.slug}?page=profile" class="btn btn-default btn-flat">Profile</a>
                                    </div>
                                    <div class="pull-right">
                                        <a href="${bundle.spaceLocation}/app/logout" class="btn btn-default btn-flat">Sign out</a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>
</header>