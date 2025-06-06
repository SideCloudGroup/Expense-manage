<script src="https://cdn.jsdelivr.net/npm/@tabler/core@latest/dist/js/tabler.min.js"></script>

<script>
    htmx.on("htmx:afterRequest", function (evt) {
        let res = JSON.parse(evt.detail.xhr.response);
        const timeout = 1000;

        if (res.ret === 1) {
            Swal.fire({
                heightAuto: false,
                icon: 'success',
                title: '成功',
                text: res.msg,
                showConfirmButton: true,
                timer: 2000,
                timerProgressBar: true,
                allowOutsideClick: false,
            });
        } else {
            Swal.fire({
                heightAuto: false,
                icon: 'error',
                title: '操作失败',
                text: res.msg
            });
        }

        if (evt.detail.xhr.getResponseHeader('HX-Redirect')) {
            return;
        }
        if (evt.detail.xhr.getResponseHeader('HX-Refresh')) {
            setTimeout(function () {
                location.reload();
            }, timeout);
        }
    });
</script>