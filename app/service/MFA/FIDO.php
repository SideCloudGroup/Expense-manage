<?php
declare (strict_types=1);

namespace app\service\MFA;

use app\model\MFACredential;
use app\model\User;
use Exception;
use think\facade\Cache;
use think\facade\Request;
use Webauthn\PublicKeyCredentialCreationOptions;
use Webauthn\AuthenticatorAssertionResponse;
use Webauthn\AuthenticatorAttestationResponse;
use Webauthn\AuthenticatorSelectionCriteria;
use Webauthn\PublicKeyCredential;
use Webauthn\PublicKeyCredentialDescriptor;
use Webauthn\PublicKeyCredentialRequestOptions;
use Webauthn\PublicKeyCredentialSource;

class FIDO
{
    public static function fidoRegisterRequest(User $user): string
    {
        $rpEntity = WebAuthn::generateRPEntity();
        $userEntity = WebAuthn::generateUserEntity($user);
        $authenticatorSelectionCriteria = AuthenticatorSelectionCriteria::create();
        $publicKeyCredentialCreationOptions =
            PublicKeyCredentialCreationOptions::create(
                $rpEntity,
                $userEntity,
                random_bytes(32),
                pubKeyCredParams: WebAuthn::getPublicKeyCredentialParametersList(),
                authenticatorSelection: $authenticatorSelectionCriteria,
                attestation: PublicKeyCredentialCreationOptions::ATTESTATION_CONVEYANCE_PREFERENCE_NONE,
                timeout: WebAuthn::$timeout,
            );
        $serializer = WebAuthn::getSerializer();
        $jsonObject = $serializer->serialize($publicKeyCredentialCreationOptions, 'json');
        Cache::set('fido_register:' . session_id(), $jsonObject, 300);
        return $jsonObject;
    }

    public static function fidoRegisterHandle(User $user, array $data): array
    {
        $serializer = WebAuthn::getSerializer();

        try {
            $publicKeyCredential = $serializer->deserialize(
                json_encode($data),
                PublicKeyCredential::class,
                'json'
            );
        } catch (Exception $e) {
            return ['ret' => 0, 'msg' => $e->getMessage()];
        }
        if (!isset($publicKeyCredential->response) || !$publicKeyCredential->response instanceof AuthenticatorAttestationResponse) {
            return ['ret' => 0, 'msg' => '密钥类型错误'];
        }

        $publicKeyCredentialCreationOptions = $serializer->deserialize(
            Cache::get('fido_register:' . session_id()),
            PublicKeyCredentialCreationOptions::class,
            'json'
        );

        try {
            $authenticatorAttestationResponseValidator = WebAuthn::getAuthenticatorAttestationResponseValidator();
            $publicKeyCredentialSource = $authenticatorAttestationResponseValidator->check(
                $publicKeyCredential->response,
                $publicKeyCredentialCreationOptions,
                Request::host()
            );
        } catch (Exception) {
            return ['ret' => 0, 'msg' => '验证失败'];
        }
        $jsonStr = WebAuthn::getSerializer()->serialize($publicKeyCredentialSource, 'json');
        $jsonObject = json_decode($jsonStr);
        $mfaCredential = new MFACredential();
        $mfaCredential->userid = $user->id;
        $mfaCredential->rawid = $jsonObject->publicKeyCredentialId;
        $mfaCredential->body = $jsonStr;
        $mfaCredential->created_at = date('Y-m-d H:i:s');
        $mfaCredential->used_at = null;
        $mfaCredential->name = $data['name'] === '' ? null : $data['name'];
        $mfaCredential->type = 'fido';
        $mfaCredential->save();
        return ['ret' => 1, 'msg' => '注册成功'];
    }

    public static function fidoAssertRequest(User $user): string
    {
        $serializer = WebAuthn::getSerializer();
        $userCredentials = (new MFACredential())
            ->where('userid', $user->id)
            ->where('type', 'fido')
            ->field('body')
            ->select();
        $credentials = [];
        foreach ($userCredentials as $credential) {
            $credentials[] = $serializer->deserialize($credential->body, PublicKeyCredentialSource::class, 'json');
        }
        $allowedCredentials = array_map(
            static function (PublicKeyCredentialSource $credential): PublicKeyCredentialDescriptor {
                return $credential->getPublicKeyCredentialDescriptor();
            },
            $credentials
        );
        $publicKeyCredentialRequestOptions = PublicKeyCredentialRequestOptions::create(
            random_bytes(32),
            rpId: Request::host(),
            allowCredentials: $allowedCredentials,
            userVerification: 'discouraged',
            timeout: WebAuthn::$timeout,
        );
        $jsonObject = $serializer->serialize($publicKeyCredentialRequestOptions, 'json');
        Cache::set('fido_assertion:' . session_id(), $jsonObject, 300);
        return $jsonObject;
    }

    public static function fidoAssertHandle(User $user, array $data): array
    {
        $serializer = WebAuthn::getSerializer();
        $publicKeyCredential = $serializer->deserialize(json_encode($data), PublicKeyCredential::class, 'json');
        if (!$publicKeyCredential->response instanceof AuthenticatorAssertionResponse) {
            return ['ret' => 0, 'msg' => '验证失败'];
        }
        $publicKeyCredentialSource = (new MFACredential())
            ->where('rawid', $data['id'])
            ->where('userid', $user->id)
            ->where('type', 'fido')
            ->findOrEmpty();
        if ($publicKeyCredentialSource->isEmpty()) {
            return ['ret' => 0, 'msg' => '设备未注册'];
        }
        try {
            $publicKeyCredentialRequestOptions = $serializer->deserialize(
                Cache::get('fido_assertion:' . session_id()),
                PublicKeyCredentialRequestOptions::class,
                'json'
            );
            $authenticatorAssertionResponseValidator = WebAuthn::getAuthenticatorAssertionResponseValidator();
            $publicKeyCredentialSource_body = $serializer->deserialize($publicKeyCredentialSource->body, PublicKeyCredentialSource::class, 'json');
            $result = $authenticatorAssertionResponseValidator->check(
                $publicKeyCredentialSource_body,
                $publicKeyCredential->response,
                $publicKeyCredentialRequestOptions,
                Request::host(),
                $user->uuid,
            );
        } catch (Exception $e) {
            return ['ret' => 0, 'msg' => $e->getMessage()];
        }
        $publicKeyCredentialSource->body = $serializer->serialize($result, 'json');
        $publicKeyCredentialSource->used_at = date('Y-m-d H:i:s');
        $publicKeyCredentialSource->save();
        return ['ret' => 1, 'msg' => '验证成功', 'userid' => $user->id];
    }
}
