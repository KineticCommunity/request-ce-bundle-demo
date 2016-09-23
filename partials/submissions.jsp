<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<div class="box box-primary">
    <div class="box-header with-border">
        <h3 class="box-title">My Requests</h3>
    </div><!-- /.box-header -->
    <div class="box-body">
        <table class="table table-hover datatable nosearch">
            <thead>
                <tr>
                    <th>Item Requested</th>
                    <th>Details</th>
                    <th>Date Submitted</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${submissionsList}" begin="0" end="4" var="submission">
                    <c:set var="statusColor" value="label-success"/>
                    <c:choose> 
                        <c:when test="${submission.coreState eq 'Draft'}">
                            <c:set var="statusColor" value="label-warning"/>
                        </c:when>
                        <c:when test="${submission.coreState eq 'Submitted'}">
                            <c:set var="statusColor" value="label-success"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusColor" value="label-primary"/>
                        </c:otherwise>
                    </c:choose>
                    <tr>
                        <td>${text.escape(submission.form.name)}</td>
                        <td>
                            <c:choose>
                                <c:when test="${submission.coreState eq 'Draft'}">
                                    <a href="${bundle.spaceLocation}/submissions/${submission.id}">${text.escape(submission.label)}</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${bundle.kappLocation}?page=submission&id=${submission.id}">${text.escape(submission.label)}</a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td data-moment>${time.format(submission.createdAt)}</td>
                        <td><span class="label ${statusColor}">${submission.coreState}</span></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div><!-- /.box-body -->
    <div class="box-footer text-center">
        <a href="${bundle.kappLocation}?page=submissions&type=request" class="uppercase">View All Requests</a>
    </div><!-- /.box-footer -->
</div>