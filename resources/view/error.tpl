<head>
    <meta charset="UTF-8">
    <title>错误</title>
</head>
<body>
<div class="modal" id="alert" tabindex="-1">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-status bg-danger"></div>
            <div class="modal-body text-center py-4">
                <svg class="icon mb-2 text-danger icon-lg" fill="none" height="24" stroke="currentColor"
                     stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 24 24" width="24"
                     xmlns="http://www.w3.org/2000/svg">
                    <path d="M0 0h24v24H0z" fill="none" stroke="none"/>
                    <path d="M12 9v2m0 4v.01"/>
                    <path d="M5 19h14a2 2 0 0 0 1.84 -2.75l-7.1 -12.25a2 2 0 0 0 -3.5 0l-7.1 12.25a2 2 0 0 0 1.75 2.75"/>
                </svg>
                <h3>程序运行时出现错误</h3>
                <div class="text-muted">{$msg}</div>
            </div>
            <div class="modal-footer">
                <div class="w-100">
                    <div class="row">
                        <div class="col">
                            <button class="btn w-100" data-bs-dismiss="modal" onclick="goBack()"
                                    type="button">返回
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
{include file="/footer"}
<script>
    var myModal = new tabler.bootstrap.Modal(document.getElementById('alert'), {
        keyboard: false
    })
    myModal.show()
</script>
<script>
    function goBack() {
        window.history.go(-1);
    }
</script>
</body>