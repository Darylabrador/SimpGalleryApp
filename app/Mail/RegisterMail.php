<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class RegisterMail extends Mailable
{
    use Queueable, SerializesModels;

    public $identity;
    public $url;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($identity, $url)
    {
        $this->identity = $identity;
        $this->url      =  $url;
        $this->subject("SimpGalleryApp - Confirmation d'inscription");
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->view('mails.register');
    }
}
