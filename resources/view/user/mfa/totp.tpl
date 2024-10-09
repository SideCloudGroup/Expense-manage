<script src="https://fastly.jsdelivr.net/npm/qrcode_js@latest/qrcode.min.js"></script>

<div class="col-sm-12 col-md-12 mb-3">
    <div class="card">
        <div class="card-body">
            <h3 class="card-title">TOTP
                {if sizeof($totp_devices) > 0}
                    <span class="badge bg-green text-green-fg">已启用</span>
                {else}
                    <span class="badge bg-red text-red-fg">未启用</span>
                {/if}
            </h3>
            <p class="card-subtitle">TOTP 是一种基于时间的一次性密码算法，可以使用 Google Authenticator 或者 Authy
                等客户端进行验证</p>
        </div>
        <div class="card-footer">
            <div class="d-flex">
                {if sizeof($totp_devices) > 0}
                    <button class="btn btn-red ms-auto"
                            hx-delete="/user/totp_reg"
                            hx-confirm="确认禁用TOTP？"
                            hx-swap="none">
                        禁用
                    </button>
                {else}
                    <button class="btn btn-primary ms-auto" id="enableTotp">
                        启用
                    </button>
                {/if}
            </div>
        </div>
    </div>
</div>

<div class="modal" id="totpModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">设置TOTP</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center">
                <div class="row">
                    <div class="col-md-12">
                        <p>请使用 Google Authenticator 或者 Authy 扫描下面的二维码</p>
                    </div>
                    <div class="col-md-12 d-flex justify-content-center align-items-center">
                        <div id="qrcode"></div>
                    </div>
                    <div class="col-md-12">
                        <p>若无法扫描二维码，可以手动输入以下密钥</p>
                        <p id="totpSecret"></p>
                    </div>
                    <div class="col-md-12">
                        <input type="text" id="totpCode" placeholder="输入TOTP代码" class="form-control mx-auto">
                    </div>
                </div>
                <div id="qrcode"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="submitTotp">提交</button>
            </div>
        </div>
    </div>
</div>
{if sizeof($totp_devices) == 0}
    <script>
        document.querySelector('#enableTotp').addEventListener('click', async () => {
            const resp = await fetch('/user/totp_reg');
            const data = await resp.json();
            var modal = new bootstrap.Modal(document.getElementById('totpModal'), {
                backdrop: 'static',
                keyboard: false
            });
            if (data.ret === 1) {
                let qrcodeElement = document.getElementById('qrcode');
                qrcodeElement.innerHTML = '';
                let totpSecret = document.getElementById('totpSecret');
                totpSecret.innerHTML = data.token;
                let qrcode = new QRCode(qrcodeElement, {
                    text: data.url,
                    width: 256,
                    height: 256,
                    colorDark: '#000000',
                    colorLight: '#ffffff',
                    correctLevel: QRCode.CorrectLevel.H
                });
                modal.show();
            } else {
                var fail_modal = new bootstrap.Modal(document.getElementById('fail-dialog'));
                document.getElementById('fail-message').innerText = data.msg;
                fail_modal.show();
            }
        });

        document.getElementById('submitTotp').addEventListener('click', function () {
            var totpCode = document.getElementById('totpCode').value;

            fetch('/user/totp_reg', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                {literal}
                body: JSON.stringify({code: totpCode}),
                {/literal}
            })
                .then(response => response.json())
                .then(data => {
                    var totpModal = new bootstrap.Modal(document.getElementById('totpModal'));
                    var successDialog = new bootstrap.Modal(document.getElementById('success-dialog'));
                    var failDialog = new bootstrap.Modal(document.getElementById('fail-dialog'));

                    if (data.ret === 1) {
                        totpModal.hide();
                        document.getElementById("success-message").innerHTML = data.msg;
                        successDialog.show();
                        setTimeout(function () {
                            location.reload();
                        }, 1000);
                    } else {
                        document.getElementById("fail-message").innerHTML = data.msg;
                        failDialog.show();
                    }
                })
        });
    </script>
{/if}