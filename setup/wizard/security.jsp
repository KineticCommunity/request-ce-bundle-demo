<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../../bundle/initialization.jspf" %>

<hr /><c:import url="${bundle.path}/setup/wizard/progress.jsp" charEncoding="UTF-8"/><hr />

<!-- SECURITY POLICY DEFINITIONS -->
<div class="security-policy-definitions text-left">
    <h3>Security Policy Definitions</h3>
    <table class="table table-hover">
        <thead>
            <tr>
                <th>Name</th>
                <th>Type</th>
                <th>Message</th>
                <th width="10%"></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${SetupHelper.getSecurityPolicyDefinitions()}" var="securityPolicyDefinition">
                <c:set var="json" value="${Text.escape(Json.toString(securityPolicyDefinition))}"/>
                <c:choose>
                    <c:when test="${not empty kapp.getSecurityPolicyDefinition(securityPolicyDefinition.name)}">
                        <c:set var="securityPolicyDefinition" value="${kapp.getSecurityPolicyDefinition(securityPolicyDefinition.name)}"/>
                        <c:set var="status" value="${true}"/>
                    </c:when>
                    <c:otherwise><c:set var="status" value="${false}"/></c:otherwise>
                </c:choose>
                <tr data-json="${status ? '' : json}" data-status="${status}" class="${status ? 'success' : 'warning'}">
                    <td>${securityPolicyDefinition.name}</td>
                    <td>${securityPolicyDefinition.type}</td>
                    <td>${securityPolicyDefinition.message}</td>
                    <td>
                        <c:choose>
                            <c:when test="${status}">
                                <span class="label label-success"><span class="fa fa-check"></span> Configured</span>
                            </c:when>
                            <c:otherwise>
                                <span class="label label-danger"><span class="fa fa-times"></span> Not Configured</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            
        </tbody>
    </table>
</div>
<hr /> 
<!-- SECURITY POLICIES -->
<div class="security-policies text-left">
    <h3>Security Policies</h3>
    <table class="table table-hover">
        <thead>
            <tr>
                <th>Endpoint</th>
                <th>Name</th>
                <th width="10%"></th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${SetupHelper.getSecurityPolicies()}" var="securityPolicy">
                <c:set var="securityPolicyStatus" value="${not empty kapp.getSecurityPolicy(securityPolicy.endpoint) && Text.equals(kapp.getSecurityPolicy(securityPolicy.endpoint).name, securityPolicy.name)}"/>
                <tr data-json="${Text.escape(Json.toString(securityPolicy))}" data-status="${securityPolicyStatus}" 
                        class="${securityPolicyStatus ? 'success' : 'warning'}">
                    <td>${securityPolicy.endpoint}</td>
                    <td>${securityPolicy.name}</td>
                    <td>
                        <c:choose>
                            <c:when test="${securityPolicyStatus}">
                                <span class="label label-success"><span class="fa fa-check"></span> Configured</span>
                            </c:when>
                            <c:otherwise>
                                <span class="label label-danger"><span class="fa fa-times"></span> Not Configured</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            
        </tbody>
    </table>
</div>

<c:import url="${bundle.path}/setup/wizard/navigation.jsp" charEncoding="UTF-8"/>