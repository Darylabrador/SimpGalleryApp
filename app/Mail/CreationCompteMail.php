<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class CreationCompteMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public $sendingMessage;
    public $shareToken;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($sendingMessage, $shareToken)
    {
        $this->sendingMessage  = $sendingMessage;
        $this->shareToken      = $shareToken;
        $this->subject("SimpGalleryApp - Invitation à un album");
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->view('mails.createAccount');
    }
}
