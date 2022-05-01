$('document').ready(function() {
    doneButtonAction()
    newTodoButtonAction()
    cancelTodoButtonAction()
    submitTodoButtonAction()
})

async function getToken() {
    let response = await fetch("http://localhost:8080/api/v1/get-token")
    let data = await response.text()
    return data
}

function newTodoButtonAction() {
    $('#new-button').click(function() {
        $('#new-todo-modal').toggleClass("hidden")
    })
}

function cancelTodoButtonAction() {
    $('#cancel-button').click(function() {
        $('#new-todo-modal').toggleClass("hidden")
    })
}

function submitTodoButtonAction() {
    $('#submit-button').click(async function() {
        let title = $('#title-text').val()
        let descriptions = $('#descriptions-text').val()
        let token = await getToken()
        
        let requestObj = {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({
                title: title,
                descriptions: descriptions
            })
        }
        
        let request = new Request('http://localhost:8080/api/v1/todos', requestObj)
        let response = await fetch(request)
        if (response.status == 200) {
            window.location.replace(window.location.origin + "/todos")
        }
    })
}

function doneButtonAction() {
    $('.done-button').click(async function() {
        let token = await getToken()
        let requestObj = {
            method: 'DELETE',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            }
        }
        let request = new Request(`http://localhost:8080/api/v1/todos/${this.id}`, requestObj)
        let response = await fetch(request)
        if (response.status == 200) {
            window.location.replace(window.location.origin + "/todos")
        }
    })
}
