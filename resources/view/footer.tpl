<script src="https://cdn.jsdelivr.net/npm/@tabler/core@latest/dist/js/tabler.min.js"></script>

<script>
    htmx.on("htmx:afterRequest", function (evt) {
        // 只处理JSON响应，跳过HTML响应
        const contentType = evt.detail.xhr.getResponseHeader('Content-Type');
        if (!contentType || !contentType.includes('application/json')) {
            return; // 不是JSON响应，直接返回
        }

        try {
            let res = JSON.parse(evt.detail.xhr.response);

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
        } catch (e) {
        }
    });
</script>