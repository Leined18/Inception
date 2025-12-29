<?php
/*
Plugin Name: Redis User Banner
Description: Muestra un banner elegante en la home si Redis está activo y la información del usuario danpalac.
Version: 1.0
Author: danpalac
*/

// Hook para mostrar el banner en la home
add_action('wp_body_open', function() {
    if (!is_front_page()) return;
    // Verifica si el plugin Redis Object Cache está activo
    $redis_active = defined('WP_REDIS_HOST') && function_exists('wp_cache_get') && wp_cache_get('test', 'test') !== false;
    $banner = $redis_active ? '<span style="color:#fff;background:#27ae60;padding:4px 12px;border-radius:6px;font-weight:bold;">Redis Cache: Activo</span>'
                            : '<span style="color:#fff;background:#c0392b;padding:4px 12px;border-radius:6px;font-weight:bold;">Redis Cache: Inactivo</span>';
    // Obtiene el usuario danpalac
    $user = get_user_by('login', 'danpalac');
    if ($user) {
        $avatar = get_avatar_url($user->ID, ['size'=>96]);
        $display = esc_html($user->display_name);
        $email = esc_html($user->user_email);
        echo '<div style="margin:32px auto 24px auto;max-width:480px;text-align:center;box-shadow:0 2px 16px #0002;padding:32px 16px;border-radius:16px;background:#fff;">
            <div style="margin-bottom:16px;">'.$banner.'</div>
            <img src="'.$avatar.'" alt="Avatar" style="border-radius:50%;width:96px;height:96px;box-shadow:0 2px 8px #0001;">
            <h2 style="margin:16px 0 8px 0;font-family:sans-serif;font-size:2rem;color:#222;">'.$display.'</h2>
            <div style="color:#666;font-size:1.1rem;">'.$email.'</div>
        </div>';
    }
});
