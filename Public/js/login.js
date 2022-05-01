$('document').ready(function() {
    loginButtonAction()
})

function loginButtonAction() {
    $('#login-button').click(async function() {
        let username = $('#username-text').val()
        let requestObj = {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                username: username
            })
        }
        let request = new Request('http://localhost:8080/api/v1/login', requestObj)
        let response = await fetch(request)
        if (response.status == 200) {
            window.location.replace(window.location.origin + "/todos")
        }
    })
}
