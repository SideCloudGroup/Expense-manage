{switch :getSetting('captcha_driver')}
{case numeric}
    <label class="form-label"><i class="fas fa-key"></i> 验证码</label>
    <div class="row">
        <div class="col">
            <div class="input-group input-group-flat">
                <input autocomplete="off" class="form-control" name="captcha"
                       placeholder="请输入验证码" type="text">
            </div>
        </div>
        <div class="col">
            <img alt="captcha" onClick="refreshCaptcha();"
                 src="{:captcha_src()}"/>
        </div>
    </div>
    <script>
        function refreshCaptcha() {
            $('img[alt="captcha"]').attr('src', '{:captcha_src()}?' + Math.random());
        }
    </script>
{/case}
{case turnstile}
    <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
    <div class="cf-turnstile" data-sitekey="{:getSetting('captcha_siteKey')}" data-theme="light"></div>
    <script>
        function refreshCaptcha() {
            turnstile.reset(document.getElementById('turnstile'));
        }
    </script>
{/case}
{case hcaptcha}
    <script src="https://js.hcaptcha.com/1/api.js" async defer></script>
    <div class="h-captcha" data-sitekey="{:getSetting('captcha_siteKey')}"></div>
    <script>
        function refreshCaptcha() {
            hcaptcha.reset(document.getElementById('hcaptcha'));
        }
    </script>
{/case}
{case cap}
    <script src="https://cdn.jsdelivr.net/npm/@cap.js/widget"></script>
    <cap-widget id="cap"
                data-cap-api-endpoint="{:getSetting('captcha_customUrl')}/{:getSetting('captcha_siteKey')}/">
    </cap-widget>
    <script>
        function refreshCaptcha() {
            document.querySelector("#cap").reset();
        }
    </script>
{/case}
{/switch}

{if getSetting('captcha_driver')!='none'}
    <script>
        htmx.on("htmx:afterRequest", function (evt) {
            let res = JSON.parse(evt.detail.xhr.response);
            if (res.ret === 0) {
                refreshCaptcha();
            }
        });
    </script>
{/if}