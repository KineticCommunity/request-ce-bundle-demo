<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<c:set var="status" value="${Text.defaultIfBlank(param['status'],'Submitted')}" />
<c:set var="paramtype" value="${Text.defaultIfBlank(param['type'],'assets')}" />
<c:set var="adminKapp" value="${space.getKapp(Text.defaultIfBlank(space.getAttributeValue('Admin Kapp Slug'),'admin'))}"/>
<c:choose>
     <c:when test="${paramtype eq 'assets'}">
        <c:if test="${BundleHelper.hasForm('admin','user-assets')}">
            <c:set var="params" value="${BridgedResourceHelper.map()}"/>
            <c:set target="${params}" property="User" value="${identity.username}"/>
            <c:set scope="request" var="submissionsList" value="${BridgedResourceHelper.search('User Assets',params)}"/>
            <c:set scope="request" var="type" value="Assets"/>
            <c:set scope="request" var="form" value="${adminKapp.getForm('user-assets')}" />
        </c:if>
    </c:when>
</c:choose>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(space.name)} Submissions</title>
    </bundle:variable>
    <section class="content-header">
        <h1>
            My ${type}
        </h1>
        <ol class="breadcrumb">
            <li><a href="#">
                <i class="fa fa-home"></i> 
                Home</a>
            </li>
            <li class="active">My ${type}</li>
        </ol>
    </section>
    <section class="content">
        <div class="nav-tabs-custom ">
            <div class="tab-content">
                <div id="tab_1" class="tab-pane <c:if test="${status eq 'Submitted'}">active</c:if>">
                    <table class="table table-hover datatable">  
                        <thead>
                            <tr>
                                <c:forEach var="bridgeAttribute" items="${form.getAttributeValues('Bridge Attribute')}">
                                    <th>${bridgeAttribute}</th>
                                </c:forEach>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${submissionsList}" var="submission">
                                <tr>
                                    <c:forEach var="bridgeAttribute" items="${form.getAttributeValues('Bridge Attribute')}">
                                        <td>${text.escape(submission.get(bridgeAttribute))}</td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div><!-- End Tab 1 -->
            </div>
        </div>
    </section>
</bundle:layout>