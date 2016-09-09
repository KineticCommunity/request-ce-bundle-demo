<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="bundle/initialization.jspf" %>
<bundle:layout page="layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(kapp.name)} Login</title>
    </bundle:variable>
    <!-- Logo -->
    <div class="login-logo">
      <a href="#" class="logo">
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"> 
                <c:choose>
                    <c:when test="${not empty space.getAttribute('Company Name') && not empty space.getAttributeValue('Company Name')}">
                        ${space.getAttributeValue('Company Name')}
                    </c:when>
                    <c:otherwise>
                        ${space.name}
                    </c:otherwise>
                </c:choose>
          </span>
      </a>
    </div>
    <div class="login-box-body">
      <section>
        <p class="login-box-msg" style="padding-top:15px;">Sign in to start your session</p>
        <form action="<c:url value="/${space.slug}/app/login.do"/>" method="POST">
            <!-- CSRF Token field -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <!-- Space to login to -->
            <input type="hidden" name="j_space" value="${space.slug}"/>

            <!-- Kapp to login to -->
            <input type="hidden" name="j_kapp" value="${kapp.slug}"/>

            <!-- Username field -->
            <div class="form-group">
              <label for="j_username">User Name</label>
              <input type="text" name="j_username" id="j_username" class="form-control" autofocus/>
            </div>

            <!-- Password field -->
            <div class="form-group">
              <label for="j_password">Password</label>
              <input type="password" name="j_password" id="j_password" class="form-control" autocomplete="off"/>
            </div>

            <div class="form-group">
              <button id="submit" type="submit" class="btn btn-primary btn-block btn-flat">Login</button>
            </div>
        </form>
      </section>
    </div>
</bundle:layout>
