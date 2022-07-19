<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
    <title>Phonebook Application</title>
    <jsp:include page="header.jsp"/>
</head>
<body>
    <div class="form-control">
        <jsp:include page="title.jsp"/>
        <form action="search" method="POST">
            <jsp:include page="filter.jsp"/>
            <jsp:include page="grid.jsp"/>
        </form>
        <br/>
        <small id="messageHelp" class="form-text text-muted">${message}</small>
    </div>
    <jsp:include page="rum.jsp"/>
</body>
</html>
