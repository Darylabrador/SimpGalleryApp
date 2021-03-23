<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class DeleteAccountMail extends Mailable
{
    use Queueable, SerializesModels;

    public $identity;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($identity)
    {
        $this->identity = $identity;
        $this->subject("SimpGalleryApp - Suppresion de compte");
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->view('mails.deleteAccount');
    }
}
