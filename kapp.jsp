<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="bundle/initialization.jspf" %>
<%@include file="bundle/router.jspf" %>
<c:set var="adminKapp" value="${space.getKapp(Text.defaultIfBlank(space.getAttributeValue('Admin Kapp Slug'),'admin'))}"/>
<c:choose>
    <c:when test="${identity.anonymous}">
        <c:set var="kapp" scope="request" value="${kapp}"/>
        <c:redirect url="/${space.slug}/app/login?kapp=${kapp.slug}"/>
    </c:when>
    <c:otherwise>
        <bundle:layout page="${bundle.path}/layouts/layout.jsp">
            <bundle:variable name="head">
                <title>Kinetic Data ${text.escape(kapp.name)}</title>
            </bundle:variable>
            <!-- Set variable used to count and display submissions -->
            <c:set scope="request" var="submissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Service', 'Submitted', 999)}"/>

            <%-- Set class for number of tiles displayed --%>
            <c:set var="tileCount" value="3" />
            <c:if test="${BundleHelper.checkKappAndForm('admin','user-asset')}">
                <c:set var="tileCount" value="${tileCount - 1}" />
            </c:if>
            <c:if test="${BundleHelper.checkKappAndForm('knowledge','knowledge')}">
                <c:set var="tileCount" value="${tileCount - 1}" />
            </c:if>
            <c:set scope="request" var="tileClass" value="col-sm-${tileCount}"/>
            <%-- Header --%>
            <section class="content-header">
                <h1>
                    Enterprise Request Management System
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#">
                        <i class="fa fa-home"></i> 
                        Home</a>
                    </li>
                </ol>
            </section>
            <%-- Action Tiles --%>
            <section class="content">
                <!-- Small boxes (Stat box) -->
                <div class="row">
                    <div class="${tileClass}">
                        <!-- small box -->
                        <div class="small-box bg-aqua">
                            <div class="inner">
                                <h3>${fn:length(submissionsList)}</h3>
                                <p>My Requests</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-shopping-cart"></i>
                            </div>
                            <a href="${bundle.kappLocation}?page=submissions&type=request" class="small-box-footer">View Your Requests <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div><!-- ./col -->

                    <div class="${tileClass}">
                        <!-- small box -->
                        <div class="small-box bg-green">
                            <div class="inner">
                                <h3>${fn:length(SubmissionHelper.retrieveRecentSubmissions('Approval', 'Draft',999))}</h3>
                                <p>My Approvals</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-thumbs-o-up"></i>
                            </div>
                            <a href="${bundle.kappLocation}?page=submissions&type=approval" class="small-box-footer">View Your Approvals <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div><!-- ./col -->
                    
                    <div class="${tileClass}">
                        <!-- small box -->
                        <div class="small-box bg-maroon">
                            <div class="inner">
                            <!-- Check if the space has an attribute QApp Slug so that we don't get a 500 error attmpting to get an attribute that doesn't exist-->
                            	<c:choose>
									<c:when test="${space.hasAttribute('QApp Slug')}">
                                		<h3>${fn:length(SubmissionHelper.retrieveRecentSubmissionsByKapp(space.getAttributeValue('QApp Slug'), 'Draft', 999))}</h3>
                                	</c:when>
                                	<c:otherwise>
                                		<h3>&nbsp;</h3>
                                	</c:otherwise>
                                </c:choose>
                                <p>My Tasks</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-tasks"></i>
                            </div>
                            <a target="_blank" href="${bundle.spaceLocation}/${space.getAttributeValue('QApp Slug')}#/queue/filter/__default__" class="small-box-footer">View Your Tasks <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div><!-- ./col -->

                    <c:if test="${BundleHelper.checkKappAndForm('admin','user-asset')}">
                        <c:set var="params" value="${BridgedResourceHelper.map()}"/>
                        <c:set target="${params}" property="User" value="${identity.username}"/>
                        <c:set scope="request" var="assetList" value="${BridgedResourceHelper.search('User Assets',params)}"/>
                        <div class="${tileClass}">
                            <!-- small box -->
                            <div class="small-box bg-yellow">
                                <div class="inner">
                                    <h3>${fn:length(assetList)}</h3>
                                    <p>My Assets</p>
                                </div>
                                <div class="icon">
                                    <i class="fa fa-mobile"></i>
                                </div>
                                <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                            </div>
                        </div><!-- ./col -->
                    </c:if>
                    <c:if test="${BundleHelper.checkKappAndForm('knowledge','knowledge')}">
                        <c:set scope="request" var="rkmList" value=""/>
                        <div class="${tileClass}">
                            <!-- small box -->
                            <div class="small-box bg-red">
                                <div class="inner">
                                    <h3>${rkmList}</h3>
                                    <p>Knowledge Base</p>
                                </div>
                                <div class="icon">
                                    <i class="fa fa-lightbulb-o"></i>
                                </div>
                                <a href="#" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                            </div>
                        </div><!-- ./col -->
                    </c:if>

                    <div class="${tileClass}">
                        <!-- small box -->
                        <div class="small-box bg-orange">
                            <div class="inner">
                                <h3>Help</h3>
                                <p>&nbsp;</p>
                            </div>
                            <div class="icon">
                                <i class="fa fa-life-ring"></i>
                            </div>
                            	<a <c:if test="${!empty kapp.getForm('help')}">href="${bundle.spaceLocation}/${kapp.slug}/help"</c:if> class="small-box-footer">Ask a Question <i class="fa fa-arrow-circle-right"></i></a>
                        </div>
                    </div><!-- ./col -->

                </div><!-- /.row -->

                <div class="row">
                    <div class="col-md-8">
                        <c:import url="${bundle.path}/partials/submissions.jsp" charEncoding="UTF-8"/>
                    </div>
                    <div class="col-md-4">
                        <c:import url="${bundle.path}/partials/promotedRequests.jsp" charEncoding="UTF-8"/>
                    </div>
                </div>
            </section>
        </bundle:layout>
    </c:otherwise>
</c:choose>