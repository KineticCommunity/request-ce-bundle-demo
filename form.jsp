<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="bundle/initialization.jspf" %>
<%@include file="bundle/router.jspf" %>
<bundle:layout page="layouts/form.jsp">
    <bundle:scriptpack>
        <bundle:script src="${bundle.location}/js/form.js" />
        <bundle:script src="${bundle.location}/js/formTables.js" />
    </bundle:scriptpack>
    <bundle:variable name="head">
        <title>${text.escape(form.name)}</title>
        
        <%-- If the form has a "Locked By" field and is not being displayed in review mode. --%>
        <c:if test="${form.getField('Locked By') != null && param.review == null}">
            <script>
                // Set the bundle ready callback function (this is called automatically by the 
                // application after the kinetic form has been initialized/activated)
                bundle.config.ready = function(kineticForm) {
                    // Prepare locking
                    bundle.ext.locking.observe(kineticForm, {
                        lockDuration: 15,
                        lockInterval: 10
                    });
                };
            </script>
        </c:if>
    </bundle:variable>
    <section class="page" data-page="${page.name}">
        <c:if test="${param.embedded eq null}">
            <div class="content-header">
                <c:if test="${not empty form.getAttributeValue('Image')}">
                    <img class="formlogo pull-left" src="${bundle.location}/images/forms/${form.getAttributeValue('Image')}"/>
                </c:if>
                <h1>
                    <c:if test="${form.getAttributeValue('Icon')}">
                        <i class="fa ${form.getAttributeValue('Icon')}"/>
                    </c:if>
                    ${text.escape(form.name)}
                </h1>
                <c:if test="${param.review eq null}">
                    <ol class="breadcrumb">
                        <li>
                            <a href="${bundle.kappLocation}">
                                <i class="fa fa-home"></i> 
                                Home
                            </a>
                        </li>
                        <li class="active">${text.escape(form.name)}</li>
                    </ol>
                </c:if>
            </div>
        </c:if>
        <section class="content">
            <c:if test="${param.review != null && pages.size() > 1}">
                <%-- This import added bootstrap tabs to the review form where each page is in a different tab --%>
                <c:import url="partials/review.jsp" charEncoding="UTF-8"></c:import>
            </c:if>
            <div class="errors"></div>
            <div class="box box-primary">
                <app:bodyContent/>
                <script src="${i18n.scriptPath('shared')}"></script>
                <script src="${i18n.scriptPath('bundle')}"></script>
                <script src="${i18n.scriptPath(form)}"></script>
            </div>
        </section>
    </section>
</bundle:layout>
