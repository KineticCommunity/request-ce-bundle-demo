<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<!-- The time line -->
<c:if test="${empty submission}">
    <c:set var="submission" value="${Submissions.retrieve(param.id)}" scope="request"/>
</c:if>

<c:forEach var="run" items="${TaskRuns.find(submission)}">
    <ul class="timeline">
        <!-- timeline time label -->
        <li class="time-label">
            <span data-moment class="bg-red">${time.format(submission.submittedAt)}</span>
        </li>
        <!-- /.timeline-label -->
        <!-- timeline item -->
        <c:forEach var="task" items="${run.tasks}">
            <c:set var="taskStatusIcon" value="fa-check-square-o bg-green"/>
            <c:if test="${task.status eq 'Work In Progress'}">
                <c:set var="taskStatusIcon" value="fa-wrench bg-yellow"/>
            </c:if>
            <li>
                <i class="fa ${taskStatusIcon}"></i>
                <div class="timeline-item">
                    <span class="time"><i class="fa fa-clock-o"></i> Task Status: ${text.escape(task.status)} </span>
                    <h3 class="timeline-header">${text.escape(task.name)}</h3>
                    <div class="timeline-body">
                        <dl>
                            <dt>Started at: </dt>
                            <dd data-moment-short>${time.format(task.createdAt)}</dd>
                            <dt>Last Updated at: </dt>
                            <dd data-moment-short>${time.format(task.updatedAt)}</dd>
                        </dl>
                        <c:choose>
                            <c:when test="${task.name eq 'Create AWS Stack Template'}">
                                <c:forEach var="message" items="${task.messages}" varStatus="loop">
                                    <c:if test="${loop.last}">
                                        <c:catch var="messageException">
                                            <x:parse xml="${message.message}" var="message"/>
                                            <table class="table">
                                                <tr>
                                                    <th>Resource</th>
                                                    <th>Status</th>
                                                    <th>Last Updated</th>
                                                </tr>
                                                <x:forEach select="$message/resources/resource" var="resource">
                                                    <tr>
                                                        <td><x:out select="name" /></td>
                                                        <x:set var="statusNew" select="status"/>
                                                        <td class="status"><x:out select="status"/></td>
                                                        <td data-moment><x:out select="timestamp" /></td>
                                                    </tr>
                                                </x:forEach>
                                            </table>
                                        </c:catch>   
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${not empty task.messages}">
                                    <a class="btn btn-primary btn-xs" data-toggle="collapse" href="#messages-${task.id}">Read more</a>
                                    <div class="collapse" id="messages-${task.id}">
                                        <ul class="list-unstyled">
                                            <li></li>
                                            <c:forEach var="entry" items="${task.messages}">
                                                <li><span data-moment-short>${entry.date}</span> -- ${text.escape(entry.message)}</li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>  
                    </div>
                </div>
            </li>
        </c:forEach> <!-- END timeline item -->
        <li>
          <i class="fa fa-clock-o bg-gray"></i>
        </li>
    </ul>
</c:forEach>
<script>
$(function(){
    $('td.status').each(function(){
        var arr = $(this).html().replace("CREATE_","").replace("_"," ").toLowerCase().split(' ');
        var result = "";
        for (var x=0; x<arr.length; x++)
            result+=arr[x].substring(0,1).toUpperCase()+arr[x].substring(1)+' ';
        result = result.substring(0, result.length-1);
        if ( result === "Complete" ){
            $(this).parent('tr').addClass("bg-green");
        }
        if ( result === "In Progress" ){
            $(this).parent('tr').addClass("bg-yellow");
        } 
        $(this).html(result);
    });
});
</script>