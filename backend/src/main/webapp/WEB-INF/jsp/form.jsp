<!doctype html>
<html lang="en">
<head>
    <title>Phonebook Application</title>
    <jsp:include page="header.jsp"/>
</head>
<body>
<div class="form-control">
    <jsp:include page="title.jsp"/>
    <form action="save" method="POST">
        <input type="hidden" name="id" value="${id}"/>
        <div class="col-md-3">
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" class="form-control" value="${name}"/>
                <small id="nameHelp" class="form-text text-muted">${nameMessage}</small>
            </div>
            <div class="form-group">
                <br/>
                <label for="phone">Phone</label>
                <input type="text" id="phone" name="phone" class="form-control" value="${phone}"/>
                <small id="phoneHelp" class="form-text text-muted">${phoneMessage}</small>
            </div>
            <div class="form-group">
                <br/>
                <button onclick="if(!confirm('Do you confirm the save of this item?')) { return false; }" class="btn btn-primary">Save</button>
                <button onclick="document.forms[0].action = 'search';" class="btn btn-primary">Back</button>
            </div>
        </div>
        <jsp:include page="inputHandler.jsp"/>
        <jsp:include page="rum.jsp"/>
    </form>
</div>
</body>
</html>
