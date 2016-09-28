<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<ul class="treeview-menu">
    <c:forEach items="${sidebarSubCat.getSubcategories()}" var="sidebarSubCategory">
        <c:if test="${not sidebarSubCategory.isEmpty()}">
            <li class="<c:if test="${param['category'] eq sidebarSubCategory.slug}">active</c:if>" >
                <a class="<c:if test="${category.hasNonEmptySubcategories()}"> rotate</c:if>" href="${bundle.kappLocation}?page=category&category=${text.escape(sidebarSubCategory.slug)}">
                    <i class="fa ${category.getAttributeValue('Icon')}"></i><span>${text.escape(sidebarSubCategory.name)}</span>
                    <c:choose>
                        <c:when  test="${sidebarSubCategory.hasNonEmptySubcategories()}">
                            <i class="fa fa-angle-left pull-right <c:if test="${category.hasNonEmptySubcategories()}">treeview</c:if>"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="fa fa-angle-right pull-right"></i>
                        </c:otherwise>
                    </c:choose>
                </a>
                <c:if test="${sidebarSubCategory.hasNonEmptySubcategories()}">
                    <c:set var="sidebarSubCat" value="${sidebarSubCategory}" scope="request"/>
                    <jsp:include page="sidebarSubCategory.jsp"/>
                </c:if>
            </li>
        </c:if>
    </c:forEach>                                    
</ul>